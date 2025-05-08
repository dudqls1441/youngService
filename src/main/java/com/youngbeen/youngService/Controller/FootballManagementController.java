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


    @GetMapping("/matchSchedules")
    @ResponseBody
    public Map<String, Object> getMatchSchedules() {
        logger.debug("/football/matchSchedules 요청");

        List<Map> schedules = fmService.getMatchSchedules();

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", schedules);

        return response;
    }

    /**
     * 종목 검색 결과를 처리하는 메소드
     */
    @GetMapping("/getPlayers")
    @ResponseBody
    public Map<String, Object> getPlayerList(
            @RequestParam(value = "scheduleId", required = false) Long scheduleId,
            @RequestParam(value = "type", required = false) String type) {

        logger.debug("/football/getPlayers 요청 - scheduleId: {}, type: {}", scheduleId, type);

        Map<String, Object> requestMap = new HashMap<>();

        // 기본 평가 또는 경기별 평가 구분
        if ("base".equals(type)) {
            requestMap.put("isBaseRating", true);
        } else if (scheduleId != null) {
            requestMap.put("scheduleId", scheduleId);
        }

        logger.debug("isBaseRating:::{}",requestMap.get("isBaseRating"));
        logger.debug("scheduleId:::{}",requestMap.get("scheduleId"));

        // 서비스에서 List<Map>을 직접 받아옴
        List<Map> resultArray = fmService.getPlayers(requestMap);

        logger.debug("resultArray:::{}",resultArray);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", resultArray);

        return response;
    }

    @GetMapping("/getPlayerAverageRatings")
    @ResponseBody
    public Map<String, Object> getPlayerAverageRatings() {

        logger.debug("/football/getPlayerAverageRatings 요청");

        Map<String, Object> requestMap = new HashMap<>();

        // 서비스에서 List<Map>을 직접 받아옴
        List<Map<String, Object>> resultArray = fmService.getPlayerAverageRatings();

        logger.debug("resultArray:::{}",resultArray);

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


    /**
     * 모든 선수 평가 저장 API
     */
    @PostMapping("/saveAllRatings")
    @ResponseBody
    public Map<String, Object> saveAllPlayerRatings(@RequestBody Map<String, Object> requestData) {
        logger.debug("/football/saveAllRatings 요청 - requestData: {}", requestData);

        Map<String, Object> response = new HashMap<>();

        try {
            // 일정 정보 추출
            Map<String, Object> scheduleInfo = (Map<String, Object>) requestData.get("scheduleInfo");

            // 선수 평가 데이터 추출
            List<Map<String, Object>> playerRatings = (List<Map<String, Object>>) requestData.get("playerRatings");

            // 각 선수별로 참여 여부 설정
            for (Map<String, Object> rating : playerRatings) {
                // 기본값은 "N"으로 설정
                rating.put("PARTICIPATION_YN", "N");

                // 하나라도 점수가 0보다 크면 "Y"로 설정
                if (isAnyScoreGreaterThanZero(rating)) {
                    rating.put("PARTICIPATION_YN", "Y");
                }
            }

            // 서비스 레이어에 전달
            int savedCount = fmService.saveAllPlayerRatings(scheduleInfo, playerRatings);

            response.put("success", true);
            response.put("message", savedCount + "명의 선수 평가가 저장되었습니다.");
            response.put("savedCount", savedCount);

        } catch (Exception e) {
            logger.error("선수 평가 저장 중 오류 발생: {}", e.getMessage(), e);

            response.put("success", false);
            response.put("message", "선수 평가 저장 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    @PostMapping("/teamBalancing")
    @ResponseBody
    public Map<String, Object> balanceTeams(@RequestBody Map<String, Object> requestData) {
        logger.debug("/football/teamBalancing 요청 - requestData: {}", requestData);

        List<Map<String, Object>> players = (List<Map<String, Object>>) requestData.get("players");
        int teamCount = Integer.parseInt(requestData.get("teamCount").toString());
        String algorithm = (String) requestData.get("algorithm");

        List<Map<String, Object>> teams;
        Map<String, Object> serviceResult = new HashMap<>();

        // 알고리즘에 따라 팀 구성
        if ("ml_based".equals(algorithm) || "deep_learning".equals(algorithm)) {
            // ML/DL 기반 알고리즘은 서비스 호출
            Map<String, Object> serviceRequest = new HashMap<>();
            serviceRequest.put("players", players);
            serviceRequest.put("teamCount", teamCount);
            serviceRequest.put("algorithm", algorithm);

            serviceResult = fmService.balanceTeamsWithML(serviceRequest);

            if (serviceResult.containsKey("teams") && serviceResult.get("teams") instanceof List) {
                teams = (List<Map<String, Object>>) serviceResult.get("teams");
            } else {
                // 오류 발생 시 기본 알고리즘으로 처리
                logger.warn("ML/DL 기반 팀 밸런싱 실패, 기본 알고리즘으로 대체");
                teams = createBalancedTeamsSnake(players, teamCount);
            }
        } else if ("advanced".equals(algorithm)) {
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

        // 시각화 URL 추가 (ML/DL 결과에 포함되어 있다면)
        if ("ml_based".equals(algorithm) || "deep_learning".equals(algorithm)) {
            if (serviceResult.containsKey("visualization_url")) {
                response.put("visualizationUrl", serviceResult.get("visualization_url"));
                logger.debug("visualizatuinUrl ::: {}", serviceResult.get("visualization_url"));
            }
        }


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

    /**
     * 평가 점수 중 하나라도 0보다 큰지 확인하는 메서드
     */
    private boolean isAnyScoreGreaterThanZero(Map<String, Object> rating) {
        // 확인할 점수 필드 목록
        String[] scoreFields = {
                "ATTACK_SCORE", "DEFENSE_SCORE", "STAMINA_SCORE",
                "SPEED_SCORE", "TECHNIQUE_SCORE", "TEAMWORK_SCORE"
        };

        // 각 필드를 확인하여 0보다 큰 값이 있으면 true 반환
        for (String field : scoreFields) {
            Object scoreObj = rating.get(field);
            if (scoreObj != null) {
                // Integer로 변환을 시도
                int score;
                if (scoreObj instanceof Integer) {
                    score = (Integer) scoreObj;
                } else if (scoreObj instanceof String) {
                    try {
                        score = Integer.parseInt((String) scoreObj);
                    } catch (NumberFormatException e) {
                        // 숫자로 변환할 수 없는 경우 다음 필드로 넘어감
                        continue;
                    }
                } else if (scoreObj instanceof Double || scoreObj instanceof Float) {
                    // 소수점이 있는 숫자인 경우
                    double doubleScore = ((Number) scoreObj).doubleValue();
                    score = (int) doubleScore;
                } else {
                    // 처리할 수 없는 타입인 경우 다음 필드로 넘어감
                    continue;
                }

                // 0보다 큰 점수가 있으면 참여한 것으로 간주
                if (score > 0) {
                    return true;
                }
            }
        }

        // 모든 점수가 0 이하이거나 null인 경우
        return false;
    }
}
