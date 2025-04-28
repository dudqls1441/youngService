package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.Service.impl.SubwayServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Collections;
import java.util.Map;

@Controller
@RequestMapping("/subway")
public class SubwayApiController {

    @Autowired
    private SubwayServiceImpl subwayServiceImpl;

    private static final Logger logger = LoggerFactory.getLogger(SubwayApiController.class);

    // GET /api/subway/searchLocation?stationName=가산디지털단지역
    //@GetMapping("/searchLocation")
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
}