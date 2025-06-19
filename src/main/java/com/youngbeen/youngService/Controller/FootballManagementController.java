package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.StockInfoDTO;
import com.youngbeen.youngService.Service.ExcelService;
import com.youngbeen.youngService.Service.FootballManagementService;
import com.youngbeen.youngService.Service.StockService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/football")
@RequiredArgsConstructor
public class FootballManagementController {

    @Autowired
    private FootballManagementService fmService;

    private static final Logger logger = LoggerFactory.getLogger(FootballManagementController.class);

    @Autowired
    private ExcelService excelService; // 엑셀 처리 서비스


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
     * 지난주 선수 평가 데이터 가져오기
     */
    @GetMapping("/getPreviousWeekRatings")
    @ResponseBody
    public Map<String, Object> getPreviousWeekRatings(@RequestParam Integer scheduleId) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 서비스 메서드 호출
            List<Map<String, Object>> ratings = fmService.getPreviousWeekRatings(scheduleId);

            response.put("success", true);
            response.put("data", ratings);
            return response;
        } catch (Exception e) {
            logger.error("지난주 선수 평가 데이터 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", e.getMessage());
            return response;
        }
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

    @GetMapping("/downloadExcel")
    public ResponseEntity<Resource> downloadExcel(
            @RequestParam String scheduleId,
            @RequestParam(required = false) String scheduleText) throws IOException {

        logger.debug("downloadExcel START - scheduleId: {}, scheduleText: {}", scheduleId, scheduleText);

        try {
            // 1. 데이터 조회
            Map<String, Object> params = new HashMap<>();
            if (!"base".equals(scheduleId)) {
                params.put("scheduleId", Integer.parseInt(scheduleId));
            }
            List<Map> playerData = fmService.getPlayers(params);

            logger.debug("조회된 선수 데이터 수: {}", playerData.size());

            if (playerData.isEmpty()) {
                logger.warn("선수 데이터가 없습니다.");
                return ResponseEntity.badRequest().build();
            }

            // 2. 엑셀 생성
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            try (Workbook workbook = new XSSFWorkbook()) {

                // Sheet 이름 설정 (scheduleText가 있으면 사용, 없으면 기본값)
                String sheetName = "선수평가";
                if (scheduleText != null && !scheduleText.isEmpty()) {
                    String cleanScheduleText = scheduleText.replaceAll("[^\\w\\s가-힣-]", "").trim();
                    sheetName = "선수평가(" + cleanScheduleText + ")";
                }
                Sheet sheet = workbook.createSheet(sheetName);

                // 첫 번째 행에 메타 정보 추가 (숨김 처리용)
                Row metaRow = sheet.createRow(0);
                metaRow.createCell(0).setCellValue("SCHEDULE_ID");
                metaRow.createCell(1).setCellValue(scheduleId);

                // 메타 정보 행 숨김 처리
                //sheet.setRowHidden(0, true);
                //sheet.setColumnHidden(0, true);
                metaRow.setHeightInPoints(0);

                // 헤더 생성 (2번째 행)
                Row headerRow = sheet.createRow(1);
                String[] headers = {"PLAYER_ID", "선수명", "포지션", "공격력", "수비력", "체력", "속도", "기술", "팀워크"};

//헤더 스타일 적용
                CellStyle headerStyle = workbook.createCellStyle();
                headerStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
                headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                headerStyle.setBorderTop(BorderStyle.THIN);
                headerStyle.setBorderBottom(BorderStyle.THIN);
                headerStyle.setBorderLeft(BorderStyle.THIN);
                headerStyle.setBorderRight(BorderStyle.THIN);

                for (int i = 0; i < headers.length; i++) {
                    Cell cell = headerRow.createCell(i);
                    cell.setCellValue(headers[i]);
                    cell.setCellStyle(headerStyle);

                    // PLAYER_ID 컬럼 숨김 처리
                    if (i == 0) {
                        sheet.setColumnHidden(0, true);
                    }
                }

                // 컬럼 너비 설정 - 수정된 부분
                int[] columnWidths = {3000, 10000, 5000, 5000, 5000, 5000, 5000, 5000, 5000};
                for (int i = 0; i < columnWidths.length; i++) {  // 모든 컬럼에 적용
                    sheet.setColumnWidth(i, columnWidths[i]);
                }

                // 데이터 생성 (3번째 행부터)
                int rowNum = 2;
                for (Map<String, Object> player : playerData) {
                    Row row = sheet.createRow(rowNum++);

                    try {
                        row.createCell(0).setCellValue(getNumberValue(player, "PLAYER_ID")); // PLAYER_ID 추가
                        row.createCell(1).setCellValue(getStringValue(player, "NAME"));
                        row.createCell(2).setCellValue(getStringValue(player, "POSITION"));
                        row.createCell(3).setCellValue(getNumberValue(player, "ATTACK_SCORE"));
                        row.createCell(4).setCellValue(getNumberValue(player, "DEFENSE_SCORE"));
                        row.createCell(5).setCellValue(getNumberValue(player, "STAMINA_SCORE"));
                        row.createCell(6).setCellValue(getNumberValue(player, "SPEED_SCORE"));
                        row.createCell(7).setCellValue(getNumberValue(player, "TECHNIQUE_SCORE"));
                        row.createCell(8).setCellValue(getNumberValue(player, "TEAMWORK_SCORE"));
                    } catch (Exception e) {
                        logger.error("선수 데이터 처리 중 오류: {}, 선수 데이터: {}", e.getMessage(), player);
                    }
                }
                logger.debug("데이터 행 생성 완료: {} 행", rowNum - 2);

                // 컬럼 너비 자동 조정 (PLAYER_ID 제외)
                for (int i = 1; i < headers.length; i++) {
                    sheet.autoSizeColumn(i);
                }

                workbook.write(outputStream);
                logger.debug("엑셀 파일 생성 완료: {} bytes", outputStream.size());
            }

            // 3. Resource 생성
            ByteArrayResource resource = new ByteArrayResource(outputStream.toByteArray());

            return ResponseEntity.ok()
                    .header("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
                    .contentLength(resource.contentLength())
                    .body(resource);

        } catch (Exception e) {
            logger.error("엑셀 다운로드 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }


    @PostMapping("/uploadExcel")
    public ResponseEntity<Map<String, Object>> uploadExcel(
            @RequestParam("excelFile") MultipartFile excelFile,
            @RequestParam("scheduleId") String scheduleId) {

        logger.debug("uploadExcel start");

        Map<String, Object> response = new HashMap<>();

        try {
            // 파일 유효성 검사
            if (excelFile.isEmpty()) {
                response.put("success", false);
                response.put("message", "파일이 선택되지 않았습니다.");
                return ResponseEntity.badRequest().body(response);
            }

            // 파일 확장자 검사
            String fileName = excelFile.getOriginalFilename();
            if (fileName == null || (!fileName.toLowerCase().endsWith(".xlsx") && !fileName.toLowerCase().endsWith(".xls"))) {
                response.put("success", false);
                response.put("message", "엑셀 파일(.xlsx, .xls)만 업로드 가능합니다.");
                return ResponseEntity.badRequest().body(response);
            }

            // 파일 크기 검사 (예: 10MB 제한)
            if (excelFile.getSize() > 10 * 1024 * 1024) {
                response.put("success", false);
                response.put("message", "파일 크기는 10MB를 초과할 수 없습니다.");
                return ResponseEntity.badRequest().body(response);
            }

            logger.info("Excel file upload started - File: {}, Size: {}, ScheduleId: {}",
                    fileName, excelFile.getSize(), scheduleId);

            // 엑셀 파일 파싱 및 데이터 추출
            List<Map<String, Object>> excelData = excelService.parseExcelFile(excelFile);

            // 데이터 유효성 검사
            if (excelData.isEmpty()) {
                response.put("success", false);
                response.put("message", "엑셀 파일에 유효한 데이터가 없습니다.");
                return ResponseEntity.badRequest().body(response);
            }

            // 성공 응답
            response.put("success", true);
            response.put("message", "엑셀 파일이 성공적으로 처리되었습니다.");
            response.put("data", excelData);
            response.put("totalCount", excelData.size());

            logger.info("Excel file processed successfully - Records: {}", excelData.size());

            return ResponseEntity.ok(response);

        } catch (IOException e) {
            logger.debug("Error reading excel file", e);
            response.put("success", false);
            response.put("message", "엑셀 파일을 읽는 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);

        } catch (IllegalArgumentException e) {
            logger.error("Invalid excel format", e);
            response.put("success", false);
            response.put("message", "엑셀 파일 형식이 올바르지 않습니다: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);

        } catch (Exception e) {
            logger.error("Unexpected error during excel upload", e);
            response.put("success", false);
            response.put("message", "파일 처리 중 예상치 못한 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    private String getStringValue(Map<String, Object> map, String key) {
        Object value = map.get(key);
        return value != null ? value.toString() : "";
    }

    private double getNumberValue(Map<String, Object> map, String key) {
        Object value = map.get(key);
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        try {
            return Double.parseDouble(value.toString());
        } catch (Exception e) {
            logger.warn("숫자 변환 실패: {} = {}", key, value);
            return 0.0;
        }
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
