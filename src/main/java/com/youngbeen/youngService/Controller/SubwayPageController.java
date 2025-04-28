package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.SubwayInfoDTO;
import com.youngbeen.youngService.Service.SubwayService;
import com.youngbeen.youngService.Service.impl.SubwayServiceImpl;
import jakarta.servlet.http.HttpServletRequest;
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

        try {
            List<SubwayInfoDTO> resultList = subwayService.getFilteredSubwayInfo(subwayId, statnId, updnLine);
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
        try {
            System.out.println("🔍 요청된 역 이름: " + stationName);
            Map<String, String> latLng = subwayServiceImpl.getStationLatLng(stationName);

            logger.debug("역 좌표 정보: {}", latLng);

            logger.debug("lat: {}", latLng.get("lat"));
            logger.debug("lng: {}", latLng.get("lng"));
            logger.debug("stationName: {}", latLng.get("stationName"));

            return ResponseEntity.ok(latLng);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.singletonMap("error", "좌표를 조회하는 데 실패했습니다."));
        }
    }

    @PostMapping("/bookmark")
    @ResponseBody
    public Map<String, Object> toggleBookmark(@RequestParam String line,
                                              @RequestParam String station,
                                              @RequestParam String updnLine) {
        Map<String, Object> response = new HashMap<>();
        response.put("subwayId", line);
        response.put("statnId", station);
        response.put("updnLine", updnLine);
        response.put("userId", "youngbeen");  //임시
        response.put("mode", "add");

        try {
            if(!subwayServiceImpl.checkBookmark(response)){
                subwayServiceImpl.updateBookmark(response);
                // 즐겨찾기 추가/삭제 로직 구현
                response.put("success", true);
                response.put("message", "즐겨찾기가 처리되었습니다.");
            }else{
                logger.debug("이미 즐겨찾기에 추가되어 있습니다.");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        return response;
    }
}