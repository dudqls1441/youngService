package com.youngbeen.youngService.Controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.youngbeen.youngService.DTO.ApiResponse;
import com.youngbeen.youngService.Service.ApiKeyService;
import com.youngbeen.youngService.Service.FootballManagementService;
import com.youngbeen.youngService.Service.impl.FootballManagementServiceImpl;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping("/api/v1")
@Tag(name = "YoungAPI", description = "풋살 팀 밸런싱 및 선수 평가를 위한 API")
public class YoungApiController {

    private static final Logger logger = LoggerFactory.getLogger(YoungApiController.class);

    private final FootballManagementService footballManagementService;
    private final ApiKeyService apiKeyService; // 추가

    public YoungApiController(FootballManagementService footballManagementService, ApiKeyService apiKeyService){
        this.footballManagementService = footballManagementService;
        this.apiKeyService = apiKeyService;
    }

    /**
     * 선수 평가 데이터 조회 API
     */
    @Operation(
            summary = "선수 데이터 조회",
            description = "선수 이름으로 최근 5경기 데이터를 조회합니다.",
            tags = { "선수 관리" }
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "성공적으로 조회됨",
                    content = @Content(schema = @Schema(implementation = com.youngbeen.youngService.DTO.ApiResponse.class))
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "선수를 찾을 수 없음",
                    content = @Content(schema = @Schema(implementation = com.youngbeen.youngService.DTO.ApiResponse.class))
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = com.youngbeen.youngService.DTO.ApiResponse.class))
            )
    })
    @GetMapping("/player-data")
    public ResponseEntity<Map<String, Object>> getPlayerData(
            @RequestParam String apiKey,
            @RequestParam(required = false) String playerName) {

        try {
            logger.info("컨트롤러 메서드 진입: getPlayerData - apiKey: {}, playerName: {}", apiKey, playerName);

            // 1. 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.add("X-API-Version", "1.0");
            headers.add("Cache-Control", "max-age=300");

            // 2. 파라미터 설정
            Map<String, Object> params = new HashMap<>();
            params.put("playerName", playerName);

            // 3. 서비스 호출
            List<Map<String, Object>> playerData = footballManagementService.getPlayerData(params);

            // 4. 응답 데이터 구성
            Map<String, Object> result = new HashMap<>();
            Map<String, Object> header = new HashMap<>();
            Map<String, Object> body = new HashMap<>();

            // 헤더 정보
            header.put("resultCode", "S000");
            header.put("resultMessage", playerData.isEmpty() ?
                    "선수 데이터가 존재하지 않습니다." : "선수 데이터를 성공적으로 조회했습니다.");
            header.put("successCode", "Y");

            // 바디 정보
            body.put("player", playerName);
            body.put("matchCount", playerData.size());
            body.put("data", playerData);

            // 최종 결과 맵
            result.put("header", header);
            result.put("body", body);

            logger.debug("응답 데이터: {}", result);

            return ResponseEntity
                    .status(HttpStatus.OK)
                    .headers(headers)
                    .body(result);

        } catch (NoSuchElementException e) {
            // 선수를 찾을 수 없는 경우
            Map<String, Object> result = new HashMap<>();
            Map<String, Object> header = new HashMap<>();

            header.put("resultCode", "E404");
            header.put("resultMessage", "선수를 찾을 수 없습니다: " + playerName);
            header.put("successYN", "N");

            result.put("header", header);
            result.put("body", null);

            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(result);

        } catch (IllegalArgumentException e) {
            // 잘못된 요청 파라미터
            Map<String, Object> result = new HashMap<>();
            Map<String, Object> header = new HashMap<>();

            header.put("resultCode", "E400");
            header.put("resultMessage", e.getMessage());
            header.put("successYN", "N");

            result.put("header", header);
            result.put("body", null);

            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(result);

        } catch (Exception e) {
            // 서버 오류
            logger.error("선수 데이터 조회 중 오류 발생", e);

            Map<String, Object> result = new HashMap<>();
            Map<String, Object> header = new HashMap<>();

            header.put("resultCode", "E500");
            header.put("resultMessage", "서버 오류가 발생했습니다");
            header.put("successYN", "N");
            header.put("errorDetail", e.getMessage());

            result.put("header", header);
            result.put("body", null);

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(result);
        }
    }

    /**
     * 선수 평가 데이터 저장 API
     */
    @Operation(
            summary = "선수 평가 데이터 저장",
            description = "일정 정보와 선수별 평가 데이터를 저장합니다.",
            tags = { "선수 관리" }
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "성공적으로 저장됨",
                    content = @Content(schema = @Schema(implementation = com.youngbeen.youngService.DTO.ApiResponse.class))
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "500",
                    description = "서버 오류",
                    content = @Content(schema = @Schema(implementation = com.youngbeen.youngService.DTO.ApiResponse.class))
            )
    })
    @PostMapping("/player-ratings")
    public ResponseEntity<Map<String, Object>> savePlayerRatings(
            @RequestParam String apiKey,
            @RequestBody Map<String, Object> request) {
        try {
            // 1. 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.add("X-API-Version", "1.0");
            headers.add("Cache-Control", "max-age=300");

            // 요청 검증
            if (!request.containsKey("scheduleInfo") || !request.containsKey("playerRatings")) {
                // 요청 형식 오류 응답
                Map<String, Object> result = new HashMap<>();
                Map<String, Object> header = new HashMap<>();

                header.put("resultCode", "E400");
                header.put("resultMessage", "요청에 scheduleInfo와 playerRatings가 모두 필요합니다.");
                header.put("successYN", "N");

                result.put("header", header);
                result.put("body", null);

                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .headers(headers)
                        .body(result);
            }

            // 일정 정보 추출
            Map<String, Object> scheduleInfo = (Map<String, Object>) request.get("scheduleInfo");

            // 선수 평가 데이터 추출
            List<Map<String, Object>> externalPlayerRatings = (List<Map<String, Object>>) request.get("playerRatings");

            // 선수 데이터 검증
            if (externalPlayerRatings == null || externalPlayerRatings.isEmpty()) {
                // 빈 데이터 오류 응답
                Map<String, Object> result = new HashMap<>();
                Map<String, Object> header = new HashMap<>();

                header.put("resultCode", "E400");
                header.put("resultMessage", "선수 평가 데이터가 비어있습니다.");
                header.put("successYN", "N");

                result.put("header", header);
                result.put("body", null);

                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .headers(headers)
                        .body(result);
            }

            // 내부 형식으로 선수 평가 데이터 변환
            List<Map<String, Object>> playerRatings = convertPlayerRatings(externalPlayerRatings);

            // 서비스 호출: 기존 메소드 사용
            int savedCount = footballManagementService.saveAllPlayerRatings(scheduleInfo, playerRatings);

            // 응답 데이터 구성
            Map<String, Object> result = new HashMap<>();
            Map<String, Object> header = new HashMap<>();
            Map<String, Object> body = new HashMap<>();

            // 헤더 정보
            header.put("resultCode", "S000");
            header.put("resultMessage", String.format("%d개의 선수 평가 데이터가 성공적으로 저장되었습니다.", savedCount));
            header.put("successYN", "Y");

            // 바디 정보
            body.put("totalCount", playerRatings.size());
            body.put("savedCount", savedCount);
            body.put("timestamp", LocalDateTime.now().format(DateTimeFormatter.ISO_DATE_TIME));

            // 최종 결과 맵
            result.put("header", header);
            result.put("body", body);

            logger.debug("선수 평가 저장 응답 데이터: {}", result);

            return ResponseEntity
                    .status(HttpStatus.OK)
                    .headers(headers)
                    .body(result);

        } catch (NoSuchElementException e) {
            // 요소를 찾을 수 없는 경우
            Map<String, Object> result = new HashMap<>();
            Map<String, Object> header = new HashMap<>();

            header.put("resultCode", "E404");
            header.put("resultMessage", "요청한 요소를 찾을 수 없습니다: " + e.getMessage());
            header.put("successYN", "N");

            result.put("header", header);
            result.put("body", null);

            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(result);

        } catch (IllegalArgumentException e) {
            // 잘못된 요청 파라미터
            Map<String, Object> result = new HashMap<>();
            Map<String, Object> header = new HashMap<>();

            header.put("resultCode", "E400");
            header.put("resultMessage", e.getMessage());
            header.put("successYN", "N");

            result.put("header", header);
            result.put("body", null);

            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(result);

        } catch (Exception e) {
            // 서버 오류
            logger.error("선수 평가 데이터 저장 중 오류 발생", e);

            Map<String, Object> result = new HashMap<>();
            Map<String, Object> header = new HashMap<>();

            header.put("resultCode", "E500");
            header.put("resultMessage", "서버 오류가 발생했습니다");
            header.put("successYN", "N");
            header.put("errorDetail", e.getMessage());

            result.put("header", header);
            result.put("body", null);

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(result);
        }
    }

    /**
     * 선수 평가 데이터 조회 API
     */
    @GetMapping("/player-ratings")
    public ResponseEntity<ApiResponse> getPlayerRatings(
            @RequestParam String apiKey, // API 키 파라미터
            @RequestParam(required = false) Integer scheduleId,
            @RequestParam(required = false, defaultValue = "false") boolean base) {

        try {
            Map<String, Object> params = new HashMap<>();
            if (base) {
                params.put("isBaseRating", true);
            } else {
                params.put("scheduleId", scheduleId);
                params.put("isBaseRating", false);
            }

            List<Map<String, Object>> players = footballManagementService.getPlayerAverageRatings(); //TODO 파라미터 추가하여 WHERE 조건 성립

            return ResponseEntity.ok(new ApiResponse(true, "선수 평가 데이터를 성공적으로 조회했습니다.", players));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse(false, "선수 평가 데이터 조회 중 오류가 발생했습니다: " + e.getMessage(), null));
        }
    }

    /**
     * 팀 밸런싱 API
     */
    @PostMapping("/team-balancing")
    public ResponseEntity<ApiResponse> calculateTeamBalancing(@RequestBody JsonNode request) {
        try {

            Map<String, Object> serviceRequest = new HashMap<>();
            serviceRequest.put("players", request.get("Player"));
            serviceRequest.put("teamCount", request.get("TeamCount"));
            serviceRequest.put("algorithm", request.get("Algorithm"));

            Map<String, Object> result = footballManagementService.balanceTeamsWithML(serviceRequest);

            return ResponseEntity.ok(new ApiResponse(true, "팀 밸런싱 계산이 완료되었습니다.", result));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse(false, "팀 밸런싱 계산 중 오류가 발생했습니다: " + e.getMessage(), null));
        }
    }


    /**
     * 외부 선수 평가 데이터를 내부 형식으로 변환합니다.
     */
    private List<Map<String, Object>> convertPlayerRatings(List<Map<String, Object>> externalRatings) {
        List<Map<String, Object>> internalRatings = new ArrayList<>();

        for (Map<String, Object> externalRating : externalRatings) {
            Map<String, Object> internalRating = new HashMap<>();

            // 선수 ID 처리
            // 1. 외부 요청에 선수 ID가 있는 경우
            if (externalRating.containsKey("playerId")) {
                internalRating.put("PLAYER_ID", externalRating.get("playerId"));
            }
            // 2. 선수 이름으로 ID 조회 (이름만 있는 경우)
            else if (externalRating.containsKey("playerName")) {
                // 선수 이름으로 ID를 조회하는 로직
                Long playerId = findPlayerIdByName(externalRating.get("playerName").toString());

                if (playerId != null) {
                    internalRating.put("PLAYER_ID", playerId);
                } else {
                    logger.warn("선수를 찾을 수 없음: {}", externalRating.get("playerName"));
                    continue; // 선수를 찾을 수 없으면 건너뜀
                }
            } else {
                // 선수 식별 정보가 없으면 건너뜀
                logger.warn("선수 식별 정보가 없음: {}", externalRating);
                continue;
            }

            // 평가 ID 처리 (있는 경우에만)
            if (externalRating.containsKey("ratingId")) {
                internalRating.put("RATING_ID", externalRating.get("ratingId"));
            }

            // 평가 항목들 매핑
            mapRatingFields(externalRating, internalRating);

            internalRatings.add(internalRating);
        }

        return internalRatings;
    }

    /**
     * 평가 항목들을 매핑합니다.
     */
    private void mapRatingFields(Map<String, Object> externalRating, Map<String, Object> internalRating) {
        // 필드 매핑 테이블 (외부 키 -> 내부 키)
        Map<String, String> fieldMapping = new HashMap<>();
        fieldMapping.put("attackScore", "ATTACK_SCORE");
        fieldMapping.put("defenseScore", "DEFENSE_SCORE");
        fieldMapping.put("staminaScore", "STAMINA_SCORE");
        fieldMapping.put("speedScore", "SPEED_SCORE");
        fieldMapping.put("techniqueScore", "TECHNIQUE_SCORE");
        fieldMapping.put("teamworkScore", "TEAMWORK_SCORE");
        fieldMapping.put("participationYn", "PARTICIPATION_YN");

        // 각 필드 매핑
        for (Map.Entry<String, String> entry : fieldMapping.entrySet()) {
            String externalKey = entry.getKey();
            String internalKey = entry.getValue();

            if (externalRating.containsKey(externalKey)) {
                internalRating.put(internalKey, externalRating.get(externalKey));
            }
        }

        // 참여 여부의 기본값 설정
        if (!internalRating.containsKey("PARTICIPATION_YN")) {
            internalRating.put("PARTICIPATION_YN", "Y");
        }

        // 필수 필드에 기본값 설정
        ensureRequiredFields(internalRating);
    }

    /**
     * 필수 필드가 있는지 확인하고 기본값을 설정합니다.
     */
    private void ensureRequiredFields(Map<String, Object> internalRating) {
        // 필수 평가 항목
        String[] requiredFields = {
                "ATTACK_SCORE", "DEFENSE_SCORE", "STAMINA_SCORE",
                "SPEED_SCORE", "TECHNIQUE_SCORE", "TEAMWORK_SCORE"
        };

        // 각 필드에 기본값 설정
        for (String field : requiredFields) {
            if (!internalRating.containsKey(field) || internalRating.get(field) == null) {
                internalRating.put(field, 50); // 기본값 설정
            }
        }
    }

    /**
     * 선수 이름으로 ID를 조회합니다.
     * 임시 메소드: 실제 구현에서는 데이터베이스 조회로 대체해야 합니다.
     */
    private Long findPlayerIdByName(String playerName) {
        // 실제 구현에서는 데이터베이스 조회 로직으로 교체
        logger.info("선수 이름으로 ID 조회: {}", playerName);

        return footballManagementService.getPlayerIdByName(playerName);
    }
}
