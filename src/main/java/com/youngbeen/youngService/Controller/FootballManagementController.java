package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.StockInfoDTO;
import com.youngbeen.youngService.Service.FootballManagementService;
import com.youngbeen.youngService.Service.StockService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/football")
@RequiredArgsConstructor
public class FootballManagementController {

    @Autowired
    private FootballManagementService fmService;

    private static final Logger logger = LoggerFactory.getLogger(FootballManagementController.class);


    /**
     * 종목 검색 결과를 처리하는 메소드
     */
    @GetMapping("/getPlayers")
    @ResponseBody
    public Map<String, Object> getPlayerList(@RequestParam(value = "Date", required = false) String date,
                                             HttpSession session,
                                             Model model) {
        logger.debug("/football/getPlayers 요청 -" + date);

        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("Date", date);

        // 서비스에서 List<Map>을 직접 받아옴
        List<Map> resultArray = fmService.getPlayers(requestMap);

        logger.debug("resultArray  :::{}", resultArray);


        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", resultArray);

        return response;
    }

    /**
     * 신규 선수 등록 API
     */
    @PostMapping("/registerPlayer")
    @ResponseBody
    public Map<String, Object> registerPlayer(@RequestBody Map<String, Object> playerInfo) {
        logger.debug("/football/registerPlayer 요청 - playerInfo: {}", playerInfo);

        return fmService.registerNewPlayer(playerInfo);
    }

    /**
     * 선수 삭제 API
     */
    @GetMapping("/deletePlayer")
    @ResponseBody
    public Map<String, Object> deletePlayer(@RequestParam("playerId") Long playerId) {
        logger.debug("/football/deletePlayer 요청 - playerId: {}", playerId);

        try {
            fmService.deletePlayer(playerId);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "선수가 성공적으로 삭제되었습니다.");
            return response;
        } catch (Exception e) {
            logger.error("선수 삭제 중 오류 발생: {}", e.getMessage(), e);

            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "선수 삭제 중 오류가 발생했습니다: " + e.getMessage());
            return response;
        }
    }


    @PostMapping("/teamBalancing")
    @ResponseBody
    public Map<String, Object> balanceTeams(@RequestBody Map<String, Object> requestData) {
        logger.debug("/football/teamBalancing 요청 - requestData: {}", requestData);

        List<Map<String, Object>> players = (List<Map<String, Object>>) requestData.get("players");
        int teamCount = Integer.parseInt(requestData.get("teamCount").toString());
        String algorithm = (String) requestData.get("algorithm");

        List<Map<String, Object>> teams;

        // 알고리즘에 따라 팀 구성
        if ("advanced".equals(algorithm)) {
            teams = createBalancedTeamsAdvanced(players, teamCount);
        } else {
            teams = createBalancedTeamsSnake(players, teamCount);
        }

        teams.forEach(team -> {
            String teamName = (String) team.get("name");
            List<Map<String, Object>> teamPlayers = (List<Map<String, Object>>) team.get("players");

            // 선수 이름 목록을 가져와서 쉼표로 구분하여 문자열로 변환
            String playerNamesStr = teamPlayers.stream()
                    .map(player -> (String) player.get("NAME"))
                    .collect(Collectors.joining(", "));

            logger.debug("{}팀 ({}명): {}", teamName, teamPlayers.size(), playerNamesStr);
        });

        // 팀 밸런스 점수 계산
        double balanceScore = calculateBalanceScore(teams);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("teams", teams);
        response.put("balanceScore", balanceScore);

        return response;
    }

    /**
     * 스네이크 드래프트 방식 팀 구성
     */
    private List<Map<String, Object>> createBalancedTeamsSnake(List<Map<String, Object>> players, int teamCount) {
        // 팀 객체 초기화
        List<Map<String, Object>> teams = new ArrayList<>();
        for (int i = 0; i < teamCount; i++) {
            Map<String, Object> team = new HashMap<>();
            team.put("name", "Team " + (char)('A' + i));
            team.put("players", new ArrayList<Map<String, Object>>());
            teams.add(team);
        }

        // 선수들을 종합 점수 기준으로 정렬
        players.sort((p1, p2) -> {
            double score1 = calculateTotalScore(p1);
            double score2 = calculateTotalScore(p2);
            return Double.compare(score2, score1); // 내림차순 정렬
        });

        //연습
        //1 .foreach

        List<String> playerNames = new ArrayList<>();
        players.forEach(player -> {
            String name = (String) player.get("NAME");
            playerNames.add(name);
        });
        logger.debug(playerNames.toString());

        //2. StreamAPI

        List<String> playerNames2 = players.stream()
                .map(player -> (String) player.get("NAME"))
                .collect(Collectors.toList());

        logger.debug(playerNames2.toString());



        // 스네이크 드래프트 방식으로 선수 배정
        boolean reverse = false;
        for (int i = 0; i < players.size(); i++) {
            int teamIndex = i % teamCount; // 4 %  3 = 1
            if (reverse) {
                teamIndex = teamCount - 1 - teamIndex;
            }

            // 해당 팀에 선수 추가
            List<Map<String, Object>> teamPlayers = (List<Map<String, Object>>) teams.get(teamIndex).get("players");
            teamPlayers.add(players.get(i));

            // 한 라운드가 끝나면 방향 전환
            if ((i + 1) % teamCount == 0) {
                reverse = !reverse;
            }
        }

        return teams;
    }

    /**
     * 포지션 밸런싱 방식 팀 구성
     */
    private List<Map<String, Object>> createBalancedTeamsAdvanced(List<Map<String, Object>> players, int teamCount) {
        // 팀 객체 초기화
        List<Map<String, Object>> teams = new ArrayList<>();
        for (int i = 0; i < teamCount; i++) {
            Map<String, Object> team = new HashMap<>();
            team.put("name", "Team " + (char)('A' + i));
            team.put("players", new ArrayList<Map<String, Object>>());
            teams.add(team);
        }

        // 포지션별로 선수 그룹화
        Map<String, List<Map<String, Object>>> positionGroups = new HashMap<>();
        positionGroups.put("FW", new ArrayList<>());
        positionGroups.put("MF", new ArrayList<>());
        positionGroups.put("DF", new ArrayList<>());
        positionGroups.put("GK", new ArrayList<>());

        // 선수들을 포지션별로 분류
        for (Map<String, Object> player : players) {
            String position = (String) player.get("POSITION");
            if (positionGroups.containsKey(position)) {
                positionGroups.get(position).add(player);
            } else {
                positionGroups.get("MF").add(player); // 기본값
            }
        }

        // 각 포지션 그룹 내에서 점수 기준 정렬
        for (String position : positionGroups.keySet()) {
            List<Map<String, Object>> positionPlayers = positionGroups.get(position);
            positionPlayers.sort((p1, p2) -> {
                double score1 = calculateTotalScore(p1);
                double score2 = calculateTotalScore(p2);
                return Double.compare(score2, score1); // 내림차순 정렬
            });
        }

        // 포지션별로 선수 배정 (각 포지션마다 스네이크 드래프트 적용)
        List<String> positionOrder = Arrays.asList("GK", "DF", "MF", "FW");
        for (String position : positionOrder) {
            List<Map<String, Object>> positionPlayers = positionGroups.get(position);
            boolean reverse = false;

            for (int i = 0; i < positionPlayers.size(); i++) {
                int teamIndex = i % teamCount;
                if (reverse) {
                    teamIndex = teamCount - 1 - teamIndex;
                }

                // 해당 팀에 선수 추가
                List<Map<String, Object>> teamPlayers = (List<Map<String, Object>>) teams.get(teamIndex).get("players");
                teamPlayers.add(positionPlayers.get(i));

                // 한 라운드가 끝나면 방향 전환
                if ((i + 1) % teamCount == 0) {
                    reverse = !reverse;
                }
            }
        }

        return teams;
    }

    /**
     * 선수 종합 점수 계산
     */
    private double calculateTotalScore(Map<String, Object> player) {
        double attackScore = getScoreValue(player, "ATTACK_SCORE");
        double defenseScore = getScoreValue(player, "DEFENSE_SCORE");
        double staminaScore = getScoreValue(player, "STAMINA_SCORE");
        double speedScore = getScoreValue(player, "SPEED_SCORE");
        double techniqueScore = getScoreValue(player, "TECHNIQUE_SCORE");
        double teamworkScore = getScoreValue(player, "TEAMWORK_SCORE");

        return (attackScore + defenseScore + staminaScore + speedScore + techniqueScore + teamworkScore) / 6.0;
    }

    /**
     * 안전하게 점수 값 가져오기
     */
    private double getScoreValue(Map<String, Object> player, String field) {
        Object value = player.get(field);
        if (value == null) {
            return 0.0;
        }

        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }

        try {
            return Double.parseDouble(value.toString());
        } catch (Exception e) {
            return 0.0;
        }
    }

    /**
     * 팀 밸런스 점수 계산 (낮을수록 균형)
     */
    private double calculateBalanceScore(List<Map<String, Object>> teams) {
        // 각 팀의 총 점수 계산
        List<Double> teamScores = teams.stream()
                .map(team -> {
                    List<Map<String, Object>> players = (List<Map<String, Object>>) team.get("players");
                    return players.stream()
                            .mapToDouble(this::calculateTotalScore)
                            .sum();
                })
                .collect(Collectors.toList());

        // 평균 팀 점수
        double avgTeamScore = teamScores.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);

        // 편차 계산 (절대값 평균)
        double balanceScore = teamScores.stream()
                .mapToDouble(score -> Math.abs(score - avgTeamScore))
                .average()
                .orElse(0.0);

        return balanceScore;
    }
}
