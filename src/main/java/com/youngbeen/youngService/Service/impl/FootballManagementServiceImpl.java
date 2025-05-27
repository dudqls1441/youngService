package com.youngbeen.youngService.Service.impl;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.youngbeen.youngService.DTO.StockInfoDTO;
import com.youngbeen.youngService.Mapper.FootballManagementMapper;
import com.youngbeen.youngService.Service.FootballManagementService;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class FootballManagementServiceImpl implements FootballManagementService {

    private static final Logger logger = LoggerFactory.getLogger(FootballManagementServiceImpl.class);

    private final FootballManagementMapper fmMapper;

    public FootballManagementServiceImpl(FootballManagementMapper fmMapper) {
        this.fmMapper = fmMapper;
    }

    @Override
    public List<Map> getPlayers(Map map) {
        logger.info("선수 정보 조회 getPlayers map {} :",map);

        List<Map> result = fmMapper.findAllPlayer(map);
        return result;
    }

    /**
     * 선수 데이터 조회 - 최근 5경기 정보
     * @param params 조회 파라미터 (playerName 필수)
     * @return 선수의 최근 5경기 데이터 목록 또는 빈 리스트
     */
    @Override
    public List<Map<String, Object>> getPlayerData(Map<String, Object> params) {
        logger.info("선수 정보 조회 getPlayerData 시작, 파라미터: {}", params);

        // 파라미터 검증
        String playerName = (String) params.get("playerName");
        if (playerName == null || playerName.trim().isEmpty()) {
            logger.error("선수 이름이 제공되지 않았습니다.");
            throw new IllegalArgumentException("선수 이름이 필요합니다.");
        }

        // 선수 ID 조회
        String playerId = fmMapper.getPlayerId(playerName);

        // 선수가 존재하지 않는 경우 예외 처리
        if (playerId == null || playerId.isEmpty()) {
            logger.warn("선수를 찾을 수 없습니다: {}", playerName);
            throw new NoSuchElementException("선수를 찾을 수 없습니다: " + playerName);
        }

        // 선수의 최근 5경기 데이터 조회
        List<Map<String, Object>> playerMatchData = fmMapper.getPlayerData(playerId);

        // 결과 로깅
        logger.info("선수 데이터 조회 완료: 경기 수 = {}", playerMatchData.size());

        // 데이터 변환 및 필요한 경우 추가 처리
        for (Map<String, Object> match : playerMatchData) {
            // 날짜 포맷 변환 예시
            if (match.containsKey("MATCH_DATE")) {
                Object dateObj = match.get("MATCH_DATE");
                if (dateObj != null) {
                    // 필요시 날짜 포맷 변환 로직
                    // match.put("MATCH_DATE_FORMATTED", formattedDate);
                }
            }

            // 필요한 경우 등급이나 점수에 대한 레이블 추가
            /*if (match.containsKey("RATING")) {
                Double rating = Double.parseDouble(match.get("RATING").toString());
                if (rating >= 8.0) {
                    match.put("PERFORMANCE", "탁월함");
                } else if (rating >= 7.0) {
                    match.put("PERFORMANCE", "우수함");
                } else if (rating >= 5.0) {
                    match.put("PERFORMANCE", "평균");
                } else {
                    match.put("PERFORMANCE", "개선 필요");
                }
            }*/
        }

        return playerMatchData;
    }

    @Override
    public List<Map<String, Object>> getPlayerAverageRatings() {
        logger.info("선수 평균치 조회 getPlayerAverageRatings");

        List<Map<String, Object>> result = fmMapper.getPlayerAverageRatings();
        return result;
    }

    /**
     * 지난주 선수 평가 데이터 가져오기
     */
    public List<Map<String, Object>> getPreviousWeekRatings(Integer scheduleId) {
        // 1. 이전 주차 scheduleId 계산 (현재 scheduleId - 1)
        Integer prevScheduleId = scheduleId - 1;

        // 2. 이전 scheduleId가 유효한지 확인
        Map<String, Object> prevSchedule = fmMapper.getScheduleById(prevScheduleId);
        if (prevSchedule == null) {
            throw new RuntimeException("이전 주차 일정을 찾을 수 없습니다: " + prevScheduleId);
        }

        // 3. 이전 일정이 완료 상태인지 확인
        String status = (String) prevSchedule.get("STATUS");
        if (!"COMPLETED".equals(status)) {
            throw new RuntimeException("이전 주차 일정이 완료되지 않았습니다: " + prevScheduleId);
        }

        // 4. 이전 일정의 선수 평가 데이터 가져오기
        Map<String, Object> params = new HashMap<>();
        params.put("scheduleId", prevScheduleId);
        params.put("isBaseRating", false);

        List<Map> prevRatings = fmMapper.findAllPlayer(params);

        // 5. 데이터가 없는 경우 확인
        if (prevRatings == null || prevRatings.isEmpty()) {
            throw new RuntimeException("이전 주차에 선수 평가 데이터가 없습니다.");
        }

        // 6. 현재 일정에 맞게 데이터 변환
        return prevRatings.stream()
                .map(r -> {
                    // 복사본 생성하여 원본 데이터 유지
                    Map<String, Object> newRating = new HashMap<>(r);
                    // SCHEDULE_ID를 현재 일정 ID로 변경
                    newRating.put("SCHEDULE_ID", scheduleId);
                    newRating.put("RATING_ID", null); // 새로운 평가로 처리하기 위해 RATING_ID 제거
                    return newRating;
                })
                .collect(Collectors.toList());
    }

    @Override
    public Long getPlayerIdByName(String name) {

        Long result = Long.valueOf(fmMapper.getPlayerId(name));
        return result;
    }

    @Override
    public List<Map> getMatchSchedules() {
        List<Map> result = fmMapper.getMatchSchedules();
        return result;
    }

    @Override
    @Transactional  // 트랜잭션 적용 (둘 다 성공하거나 둘 다 실패)
    public Map<String, Object> registerNewPlayer(Map<String, Object> playerInfo) {
        logger.info("신규 선수 등록 registerNewPlayer playerInfo: {}", playerInfo);

        Map<String, Object> result = new HashMap<>();
        try {
            // 1. 선수 정보 등록
            int playerInserted = fmMapper.insertPlayer(playerInfo);

            if (playerInserted > 0) {
                // 2. 생성된 player_id를 가져와서 선수 평가 정보에 설정
                Long playerId = (Long) playerInfo.get("playerId");

                // 선수 평가 정보 등록
                Map<String, Object> ratingInfo = new HashMap<>();
                ratingInfo.put("playerId", playerId);
                ratingInfo.put("attackScore", playerInfo.get("attackScore"));
                ratingInfo.put("defenseScore", playerInfo.get("defenseScore"));
                ratingInfo.put("staminaScore", playerInfo.get("staminaScore"));
                ratingInfo.put("speedScore", playerInfo.get("speedScore"));
                ratingInfo.put("techniqueScore", playerInfo.get("techniqueScore"));
                ratingInfo.put("teamworkScore", playerInfo.get("teamworkScore"));

                //신규 선수 등록은 LAST_UPDATE- null, schedule_id - null ,participationYn - N
                ratingInfo.put("matchDate", "");
                ratingInfo.put("scheduleId", "");
                ratingInfo.put("participationYn", "N");

                int ratingInserted = fmMapper.insertPlayerRating(ratingInfo);

                if (ratingInserted > 0) {
                    result.put("success", true);
                    result.put("message", "선수 정보가 성공적으로 등록되었습니다.");
                    result.put("playerId", playerId);
                } else {
                    throw new RuntimeException("선수 평가 정보 등록 실패");
                }
            } else {
                throw new RuntimeException("선수 정보 등록 실패");
            }
        } catch (Exception e) {
            logger.error("선수 등록 중 오류 발생: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "선수 등록 중 오류가 발생했습니다: " + e.getMessage());
        }

        return result;
    }

    @Override
    public void deletePlayer(long playerId) {
        logger.info("선수 삭제 deletePlayer playerId: {}", playerId);

        // 1. 선수 평가 정보 먼저 삭제 (외래 키 제약조건 때문)
        Map<String, Object> params = new HashMap<>();
        params.put("playerId", playerId);

        int ratingDeleted = fmMapper.deletePlayerRating(params);
        logger.debug("선수 평가 정보 삭제 결과: {}", ratingDeleted);

        // 2. 선수 정보 삭제
        int playerDeleted = fmMapper.deletePlayer(params);
        logger.debug("선수 정보 삭제 결과: {}", playerDeleted);

        // 삭제된 레코드가 없으면 예외 발생
        if (playerDeleted == 0) {
            throw new RuntimeException("삭제할 선수 정보가 존재하지 않습니다: " + playerId);
        }
    }

    @Override
    @Transactional
    public int saveAllPlayerRatings(Map<String, Object> scheduleInfo, List<Map<String, Object>> playerRatings) {
        logger.info("선수 평가 일괄 저장 - scheduleInfo: {}, 선수 수: {}", scheduleInfo, playerRatings.size());

        // 일정 ID 추출 (null이면 기본 평가)
        Object scheduleIdObj = scheduleInfo.get("scheduleId");
        Long scheduleId = null;
        String matchDate = "";
        if (scheduleIdObj != null) {
            matchDate = (String) scheduleInfo.get("scheduleText");
            if (scheduleIdObj instanceof Integer) {
                scheduleId = ((Integer) scheduleIdObj).longValue();
            } else if (scheduleIdObj instanceof Long) {
                scheduleId = (Long) scheduleIdObj;
            }
        }

        int savedCount = 0;

        // 각 선수 평가 처리
        for (Map<String, Object> playerRating : playerRatings) {
            // 필요한 파라미터 추출
            Long playerId = null;
            if (playerRating.get("PLAYER_ID") instanceof Integer) {
                playerId = ((Integer) playerRating.get("PLAYER_ID")).longValue();
            } else if (playerRating.get("PLAYER_ID") instanceof Long) {
                playerId = (Long) playerRating.get("PLAYER_ID");
            }

            Long ratingId = null;
            if (playerRating.get("RATING_ID") != null) {
                if (playerRating.get("RATING_ID") instanceof Integer) {
                    ratingId = ((Integer) playerRating.get("RATING_ID")).longValue();
                } else if (playerRating.get("RATING_ID") instanceof Long) {
                    ratingId = (Long) playerRating.get("RATING_ID");
                }
            }

            // 필수 값 확인
            if (playerId == null) {
                logger.warn("선수 ID가 누락되었습니다: {}", playerRating);
                continue;
            }

            // 평가 데이터 맵 생성
            Map<String, Object> ratingData = new HashMap<>();
            ratingData.put("playerId", playerId);
            ratingData.put("ratingId", ratingId);
            ratingData.put("scheduleId", scheduleId);
            ratingData.put("matchDate", matchDate);
            ratingData.put("attackScore", playerRating.get("ATTACK_SCORE"));
            ratingData.put("defenseScore", playerRating.get("DEFENSE_SCORE"));
            ratingData.put("staminaScore", playerRating.get("STAMINA_SCORE"));
            ratingData.put("speedScore", playerRating.get("SPEED_SCORE"));
            ratingData.put("techniqueScore", playerRating.get("TECHNIQUE_SCORE"));
            ratingData.put("teamworkScore", playerRating.get("TEAMWORK_SCORE"));

            ratingData.put("participationYn", playerRating.get("PARTICIPATION_YN"));

            // 저장 또는 업데이트
            if (ratingId == null) {
                // 새 평가 데이터 생성
                fmMapper.insertPlayerRating(ratingData);
            } else {
                // 기존 평가 데이터 업데이트
                fmMapper.updatePlayerRating(ratingData);
            }

            savedCount++;
        }

        return savedCount;
    }


    @Override
    public Map<String, Object> balanceTeamsWithML(Map<String, Object> requestMap) {
        try {
            List<Map<String, Object>> players = (List<Map<String, Object>>) requestMap.get("players");
            int teamCount = (Integer) requestMap.get("teamCount");
            String algorithm = (String) requestMap.get("algorithm");

            logger.debug("ML/DL 팀 밸런싱 요청 - 알고리즘: {}, 팀 수: {}, 선수 수: {}",
                    algorithm, teamCount, players.size());

            // Flask API 요청 데이터 구성
            Map<String, Object> flaskRequest = new HashMap<>();
            flaskRequest.put("players", players);
            flaskRequest.put("n_teams", teamCount);
            flaskRequest.put("method", algorithm);

            // Flask API 호출
            Map<String, Object> flaskResult = executeFlaskBalancing(flaskRequest);

            if (flaskResult.containsKey("teams") && flaskResult.get("teams") instanceof List) {
                // Flask로부터 받은 팀 정보 변환
                List<List<Map<String, Object>>> rawTeams = (List<List<Map<String, Object>>>) flaskResult.get("teams");
                List<Map<String, Object>> formattedTeams = convertFlaskTeamsToLocalFormat(rawTeams);

                // 팀 통계 정보 추가
                if (flaskResult.containsKey("team_stats")) {
                    List<Map<String, Object>> teamStats = (List<Map<String, Object>>) flaskResult.get("team_stats");
                    enrichTeamsWithStats(formattedTeams, teamStats);
                }

                // 시각화 URL 요청
                try {
                    Map<String, Object> visRequest = new HashMap<>();
                    visRequest.put("teams", rawTeams);
                    Map<String, Object> visResult = executeFlaskVisualization(visRequest);

                    if (visResult.containsKey("visualization_url")) {
                        flaskResult.put("visualization_url", visResult.get("visualization_url"));
                    }
                } catch (Exception e) {
                    logger.warn("시각화 생성 중 오류 발생", e);
                }

                // 결과에 변환된 팀 정보 설정
                flaskResult.put("teams", formattedTeams);
                return flaskResult;
            } else {
                throw new RuntimeException("Flask API에서 유효한 팀 정보를 반환하지 않음");
            }
        } catch (Exception e) {
            logger.error("ML/DL 팀 밸런싱 처리 중 오류 발생", e);
            return Map.of("status", "error", "message", e.getMessage());
        }
    }

    /**
     * Flask 서버에 팀 밸런싱 요청
     */
    private Map<String, Object> executeFlaskBalancing(Map<String, Object> requestData) throws Exception {
        logger.info("Flask API를 통한 팀 밸런싱 처리 시작");

        // Flask 서버 URL 설정
        String flaskApiUrl = "http://43.201.102.170:5000/football/team_balancing";

        // HTTP 클라이언트 생성
        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();

        // 데이터를 JSON으로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonData = objectMapper.writeValueAsString(requestData);

        logger.debug("jsonData::{}", jsonData);

        // HTTP 요청 생성
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(flaskApiUrl))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonData))
                .build();

        logger.debug("Flask API 요청 전송: {}", flaskApiUrl);

        // 요청 전송 및 응답 수신
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        // 응답 상태 확인
        int statusCode = response.statusCode();
        logger.info("Flask API 응답 상태 코드: {}", statusCode);

        if (statusCode != 200) {
            logger.error("Flask API 요청 실패. 상태 코드: {}, 응답: {}", statusCode, response.body());
            throw new RuntimeException("Python 팀 밸런싱 API 호출 실패. 상태 코드: " + statusCode);
        }

        // 응답 본문을 Map으로 변환
        Map<String, Object> result = objectMapper.readValue(response.body(), new TypeReference<Map<String, Object>>() {});

        logger.info("Flask API를 통한 팀 밸런싱 완료");
        return result;
    }

    /**
     * Flask 서버에 팀 시각화 요청
     */
    private Map<String, Object> executeFlaskVisualization(Map<String, Object> requestData) throws Exception {
        logger.info("Flask API를 통한 팀 시각화 처리 시작");

        // Flask 서버 URL 설정
        String flaskApiUrl = "http://43.201.102.170:5000/football/team_visualization";

        // HTTP 클라이언트 생성
        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();

        // 데이터를 JSON으로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonData = objectMapper.writeValueAsString(requestData);

        // HTTP 요청 생성
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(flaskApiUrl))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonData))
                .build();

        // 요청 전송 및 응답 수신
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        // 응답 상태 확인
        int statusCode = response.statusCode();
        if (statusCode != 200) {
            throw new RuntimeException("시각화 API 호출 실패. 상태 코드: " + statusCode);
        }

        // 응답 본문을 Map으로 변환
        return objectMapper.readValue(response.body(), new TypeReference<Map<String, Object>>() {});
    }

    /**
     * Flask 서버에서 반환한 팀 구성을 로컬 형식으로 변환
     */
    private List<Map<String, Object>> convertFlaskTeamsToLocalFormat(List<List<Map<String, Object>>> flaskTeams) {
        List<Map<String, Object>> localTeams = new ArrayList<>();

        for (int i = 0; i < flaskTeams.size(); i++) {
            List<Map<String, Object>> teamPlayers = flaskTeams.get(i);

            Map<String, Object> team = new HashMap<>();
            team.put("name", "Team " + (i + 1));
            team.put("players", teamPlayers);

            // 팀 능력치 평균 계산
            Map<String, Double> teamAvgStats = calculateTeamAverageStats(teamPlayers);
            team.put("avgStats", teamAvgStats);

            localTeams.add(team);
        }

        return localTeams;
    }

    /**
     * Flask에서 반환한 팀 통계 정보를 로컬 팀 정보에 추가
     */
    private void enrichTeamsWithStats(List<Map<String, Object>> teams, List<Map<String, Object>> teamStats) {
        for (int i = 0; i < Math.min(teams.size(), teamStats.size()); i++) {
            Map<String, Object> team = teams.get(i);
            Map<String, Object> stats = teamStats.get(i);

            // 능력치 통계 추가
            Map<String, Object> enhancedStats = new HashMap<>();
            for (Map.Entry<String, Object> entry : stats.entrySet()) {
                if (entry.getKey().startsWith("avg_") || entry.getKey().startsWith("position_")) {
                    enhancedStats.put(entry.getKey(), entry.getValue());
                }
            }

            team.put("mlStats", enhancedStats);
        }
    }

    /**
     * 팀 선수들의 평균 능력치 계산
     */
    private Map<String, Double> calculateTeamAverageStats(List<Map<String, Object>> players) {
        Map<String, Double> avgStats = new HashMap<>();

        if (players.isEmpty()) {
            return avgStats;
        }

        // 모든 능력치 필드를 합산
        String[] statFields = {"AVG_ATTACK", "AVG_DEFENSE", "AVG_STAMINA", "AVG_SPEED", "AVG_TECHNIQUE", "AVG_TEAMWORK", "TOTAL_AVERAGE"};

        for (String field : statFields) {
            double sum = 0;
            int count = 0;

            for (Map<String, Object> player : players) {
                if (player.containsKey(field) && player.get(field) != null) {
                    // 숫자로 변환 (String이나 다른 형식일 수 있음)
                    Double value;
                    if (player.get(field) instanceof Number) {
                        value = ((Number)player.get(field)).doubleValue();
                    } else {
                        try {
                            value = Double.parseDouble(player.get(field).toString());
                        } catch (NumberFormatException e) {
                            continue; // 변환 불가능한 값은 건너뜀
                        }
                    }

                    sum += value;
                    count++;
                }
            }

            if (count > 0) {
                avgStats.put(field.toLowerCase(), sum / count);
            }
        }

        // 포지션 분포 계산
        Map<String, Integer> positionCounts = new HashMap<>();
        for (Map<String, Object> player : players) {
            String position = (String) player.get("POSITION");
            if (position != null) {
                positionCounts.put(position, positionCounts.getOrDefault(position, 0) + 1);
            }
        }

        for (Map.Entry<String, Integer> entry : positionCounts.entrySet()) {
            avgStats.put("position_" + entry.getKey().toLowerCase(), (double) entry.getValue());
        }

        return avgStats;
    }
}
