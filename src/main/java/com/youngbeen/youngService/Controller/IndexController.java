package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.SubwayInfoDTO;
import com.youngbeen.youngService.DTO.WeatherDTO;
import com.youngbeen.youngService.Service.SubwayService;
import com.youngbeen.youngService.Service.WeatherService;
import com.youngbeen.youngService.Service.impl.SubwayServiceImpl;
import com.youngbeen.youngService.Service.StockService;  // 추가
import com.youngbeen.youngService.DTO.StockInfoDTO;      // 추가
import jakarta.servlet.http.HttpSession;
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
            HttpSession session,
            Model model) {

        // 로그인 여부 확인 (먼저 체크)
        if (session.getAttribute("loginMember") == null) {
            // 로그인되지 않은 사용자는 로그인 페이지로
            logger.debug("비로그인 사용자 - 로그인 페이지로 이동");
            return "redirect:/member/login";
        }

        // 임시 사용자 ID
        String userId = "";
        userId = (String) session.getAttribute("loginId");

        // 주식 즐겨찾기 정보 가져오기
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("userId", userId);
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

        // 로그인된 사용자는 index 페이지로
        logger.debug("로그인 사용자 - 인덱스 페이지로 이동");
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

    @GetMapping(value="/managementfootball")
    public String toManagementfootball() {
        return "managementfootball";
    }


}
