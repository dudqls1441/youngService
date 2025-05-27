package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.SubwayInfoDTO;
import com.youngbeen.youngService.Service.SubwayService;
import com.youngbeen.youngService.Service.impl.SubwayServiceImpl;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.locationtech.proj4j.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/subway")
public class SubwayPageController {

    @Autowired
    private SubwayService subwayService;

    @Autowired
    private SubwayServiceImpl subwayServiceImpl;

    private static final Logger logger = LoggerFactory.getLogger(SubwayPageController.class);

    @GetMapping
    public String getSubwayInfo(@RequestParam String subwayId,
                                @RequestParam String statnId,
                                @RequestParam String updnLine,
                                @RequestParam(required = false) String action,
                                Model model,
                                HttpServletRequest request) {

        // AJAX 요청인지 확인
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        List<SubwayInfoDTO> resultList = subwayService.getFilteredSubwayInfo(subwayId, statnId, updnLine);
        model.addAttribute("resultList", resultList);
        model.addAttribute("subwayId", subwayId);
        model.addAttribute("statnId", statnId);
        model.addAttribute("updnLine", updnLine);

        // AJAX 요청인 경우 부분 뷰만 반환
        if (isAjax) {
            return "fragments/subwayResults :: resultArea";
        }

        return "subwayMap";
    }

    @GetMapping("/api/arrivalInfo")
    @ResponseBody
    public Map<String, Object> getSubwayInfoApi(@RequestParam String subwayId,
                                                @RequestParam String statnId,
                                                @RequestParam String updnLine) {
        Map<String, Object> response = new HashMap<>();

        logger.debug("/api/arrivalInfo  getSubwayInfoApi");
        logger.debug("subwayId : {}  , subwayId  : {},  subwayId  : {}",subwayId, statnId, updnLine);
        try {
            List<SubwayInfoDTO> resultList = subwayService.getFilteredSubwayInfo(subwayId, statnId, updnLine);
            logger.debug("/api/arrivalInfo  resultList{} ",resultList);
            response.put("success", true);
            response.put("data", resultList);
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        return response;
    }

    @GetMapping("/favorites")
    @ResponseBody
    public Map<String, Object> getFavoriteList(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        String userId = "";
        userId = (String) session.getAttribute("loginId");

        // 주식 즐겨찾기 정보 가져오기
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("userId", userId);

        logger.debug("/api/arrivalInfo  getFavoriteList");
        try {
            List<SubwayInfoDTO> resultList = subwayService.selectBookmark(requestMap);

            logger.debug("resultList::{}",resultList);
            response.put("success", true);
            response.put("data", resultList);
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        return response;
    }

    // GET /api/subway/searchLocation?stationName=가산디지털단지역
    @GetMapping("/searchLocation")
    public ResponseEntity<Map<String, String>> getStationCoord(@RequestParam String stationName) {
        Map<String, String> response = new HashMap<>();

        try {
            System.out.println("요청된 역 이름: " + stationName);
            Map<String, String> latLng = subwayServiceImpl.getStationLatLng(stationName);

            if(latLng != null){
                String tmX = (String) latLng.get("lng");  // 또는 subwayXcnts
                String tmY = (String) latLng.get("lat");  // 또는 subwayYcnts

                // 좌표계 변환 (TM -> WGS84)
                double[] wgsCoords = convertTMToWGS84(
                        Double.parseDouble(tmX),
                        Double.parseDouble(tmY)
                );

                logger.debug("역 좌표 정보: {}", latLng);
                logger.debug("lat: {}", String.valueOf(wgsCoords[0]));
                logger.debug("lng: {}", String.valueOf(wgsCoords[1]));
                logger.debug("stationName: {}", latLng.get("stationName"));

                response.put("lat", String.valueOf(wgsCoords[0]));
                response.put("lng", String.valueOf(wgsCoords[1]));
                response.put("stationName", stationName);

                // response 맵을 반환하도록 수정
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Collections.singletonMap("error", "역을 찾을 수 없습니다."));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.singletonMap("error", "좌표를 조회하는 데 실패했습니다."));
        }
    }

    @PostMapping("/bookmark")
    @ResponseBody
    public Map<String, Object> toggleBookmark(@RequestParam String line,
                                              @RequestParam String station,
                                              @RequestParam String updnLine,
                                              @RequestParam String action,
                                              HttpSession session  ) {

        String userId = "";
        userId = (String) session.getAttribute("loginId");

        Map<String, Object> response = new HashMap<>();
        response.put("subwayId", line);
        response.put("statnId", station);
        response.put("updnLine", updnLine);
        response.put("userId", userId);  // 임시 사용자 ID

        try {
            boolean isBookmarked = subwayServiceImpl.checkBookmark(response);

            if (action.equals("add") && !isBookmarked) {
                // 북마크 추가
                logger.debug("북마크 추가");
                subwayServiceImpl.updateBookmark(response);
                setSuccessResponse(response);
            } else if (action.equals("remove") && isBookmarked) {
                // 북마크 삭제
                logger.debug("북마크 삭제");
                subwayServiceImpl.deleteBookmark(response);
                setSuccessResponse(response);
            } else {
                // 이미 추가되어 있거나 이미 삭제된 상태
                String message = action.equals("add") ?
                        "이미 즐겨찾기에 추가되어 있습니다." : "즐겨찾기에 존재하지 않습니다.";
                logger.debug(message);
                response.put("success", false);
                response.put("message", message);
            }
        } catch (Exception e) {
            logger.error("북마크 처리 중 오류 발생: " + e.getMessage(), e);
            setErrorResponse(response, e);
        }

        return response;
    }

    // 성공 응답 설정
    private void setSuccessResponse(Map<String, Object> response) {
        response.put("success", true);
        response.put("message", "즐겨찾기가 처리되었습니다.");
    }

    // 오류 응답 설정
    private void setErrorResponse(Map<String, Object> response, Exception e) {
        response.put("success", false);
        response.put("error", e.getMessage());
    }
    /**
     * TM 좌표계에서 WGS84 좌표계로 변환
     * @param tmX X 좌표 (경도)
     * @param tmY Y 좌표 (위도)
     * @return WGS84 좌표 [위도, 경도]
     */
    private double[] convertTMToWGS84(double tmX, double tmY) {
        try {
            // Proj4J 좌표 변환 시스템 설정
            CRSFactory crsFactory = new CRSFactory();

            // 한국 TM 좌표계 정의 (EPSG:5174 또는 해당하는 좌표계)
            CoordinateReferenceSystem tmCRS = crsFactory.createFromParameters(
                    "TM",
                    "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs"
            );

            // WGS84 좌표계
            CoordinateReferenceSystem wgsCRS = crsFactory.createFromParameters(
                    "WGS84",
                    "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
            );

            // 좌표 변환기 생성
            CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
            CoordinateTransform transform = ctFactory.createTransform(tmCRS, wgsCRS);

            // 좌표 변환
            ProjCoordinate tmCoord = new ProjCoordinate(tmX, tmY);
            ProjCoordinate wgsCoord = new ProjCoordinate();
            transform.transform(tmCoord, wgsCoord);

            // WGS84 좌표 반환 (위도, 경도 순서)
            return new double[] { wgsCoord.y, wgsCoord.x };
        } catch (Exception e) {
            // 변환 실패 시 로그 출력
            e.printStackTrace();
            // 기본값 또는 오류 처리
            return new double[] { 0, 0 };
        }
    }
}