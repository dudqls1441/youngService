package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.SubwayInfoDTO;
import com.youngbeen.youngService.DTO.WeatherDTO;
import com.youngbeen.youngService.Service.SubwayService;
import com.youngbeen.youngService.Service.WeatherService;
import com.youngbeen.youngService.Service.impl.SubwayServiceImpl;
import com.youngbeen.youngService.Service.StockService;  // 추가
import com.youngbeen.youngService.DTO.StockInfoDTO;      // 추가
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.ui.Model;                        // 추가
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;                               // 추가
import java.util.List;                                  // 추가
import java.util.Map;
import java.util.stream.Collectors;


@Controller
public class IndexController {

    private static final Logger logger = LoggerFactory.getLogger(IndexController.class);

    @Autowired
    private SubwayServiceImpl subwayServiceImpl;

    @Autowired
    private StockService stockService;

    @Autowired
    private WeatherService weatherService;

    @Autowired
    private SubwayService subwayService;

    @GetMapping(value="/")
    public String home(
            @RequestParam(value = "location", required = false) String location,
            Model model) {
        // 임시 사용자 ID
        String tmpUserId = "youngbeen";

        // 주식 즐겨찾기 정보 가져오기
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("userId", tmpUserId);
        requestMap.put("page", 1);
        requestMap.put("size", 5);  // 메인화면에는 5개만 표시

        List<StockInfoDTO> favoriteStocks = stockService.searchStockfavorites(requestMap);
        logger.debug("favoriteStocks::{}",favoriteStocks);

        // 위치 정보가 없으면 서울로
        if (location == null || location.isBlank()) {
            location = "인천";
        }

        // 날씨 정보 가져오기
        WeatherDTO weather = weatherService.getWeatherInfo(location);

        Map<String, Object> response = new HashMap<>();

        List<SubwayInfoDTO> subwayList = subwayService.selectBookmark();
        logger.debug("resultList::{}",subwayList);

        // 모델에 데이터 추가
        model.addAttribute("stockList", favoriteStocks);
        model.addAttribute("subwayList", subwayList);
        model.addAttribute("locationList", weatherService.getLocationList());
        model.addAttribute("selectedLocation", location);
        model.addAttribute("weather", weather);

        return "index";
    }

    @GetMapping(value="/dashboard")
    public String toSubwayMap() {
        return "subwayMap";
    }

    @GetMapping(value="/analysis")
    public String toAnaylasis() {
        return "analysis";
    }

    @GetMapping(value="/stockinfo")
    public String toStockInfo() {
        return "stockinfo";
    }

    @GetMapping(value="/performance")
    public String toPerformance() {
        return "performance";
    }


}
