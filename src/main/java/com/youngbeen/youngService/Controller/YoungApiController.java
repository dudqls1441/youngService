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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

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
    public ResponseEntity<ApiResponse> getPlayerData(
            @RequestParam String apiKey, // API 키 파라미터
            @RequestParam(required = false) String playerName) {

        try {
            Map<String, Object> params = new HashMap<>();
            params.put("playerName", playerName);

            logger.info("컨트롤러 메서드 진입: getPlayerData - apiKey: {}, playerName: {}", apiKey, playerName);

            List<Map<String, Object>> playerData = footballManagementService.getPlayerData(params);

            if (playerData.isEmpty()) {
                return ResponseEntity.ok(new ApiResponse(true, "선수 데이터가 존재하지 않습니다.", playerData));
            }
            logger.debug("playerData::{}",playerData);

            // 메타데이터 추가 (응답 데이터 보강)
            Map<String, Object> response = new HashMap<>();
            response.put("player", playerName);
            response.put("matchCount", playerData.size());
            response.put("lastUpdated", LocalDateTime.now().format(DateTimeFormatter.ISO_DATE_TIME));
            response.put("data", playerData);

            return ResponseEntity.ok(new ApiResponse(true, "선수 데이터를 성공적으로 조회했습니다.", response));
        } catch (NoSuchElementException e) {
            // 선수를 찾을 수 없는 경우 404 응답
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ApiResponse(false, e.getMessage(), null));
        } catch (IllegalArgumentException e) {
            // 잘못된 요청 파라미터인 경우 400 응답
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ApiResponse(false, e.getMessage(), null));
        } catch (Exception e) {
            logger.error("선수 데이터 조회 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse(false, "선수 데이터 조회 중 오류가 발생했습니다: " + e.getMessage(), null));
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
    public ResponseEntity<ApiResponse> savePlayerRatings(
            @RequestParam String apiKey, // 명시적으로 요청에 표시 (선택 사항, 인터셉터에서 이미 검증됨)
            @RequestBody Map<String, Object> request) {
        try {
            // 일정 정보 추출
            Map<String, Object> scheduleInfo = (Map<String, Object>) request.get("scheduleInfo");

            // 선수 평가 데이터 추출
            List<Map<String, Object>> playerRatings = (List<Map<String, Object>>) request.get("playerRatings");

            // 기존 서비스 메서드 활용
            footballManagementService.saveAllPlayerRatings(scheduleInfo, playerRatings);

            return ResponseEntity.ok(new ApiResponse(true, "선수 평가 데이터가 성공적으로 저장되었습니다.", null));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse(false, "선수 평가 데이터 저장 중 오류가 발생했습니다: " + e.getMessage(), null));
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
}
