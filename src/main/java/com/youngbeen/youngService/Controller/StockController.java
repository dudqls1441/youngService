package com.youngbeen.youngService.Controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.youngbeen.youngService.DTO.StockInfoDTO;
import com.youngbeen.youngService.Mapper.MarketSummary;
import com.youngbeen.youngService.Service.StockService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import org.springframework.ui.Model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/stock")
@RequiredArgsConstructor
public class StockController {
    @Autowired
    private StockService stockService;

    private static final Logger logger = LoggerFactory.getLogger(StockController.class);


    /**
     * 전체 주식 목록을 조회하는 메소드
     */
    @GetMapping("/list")
    public String getAllStocks(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            Model model) {

        logger.debug("/stock/list 요청 - 페이지: {}, 크기: {}", page, size);

        Map<String, Object> resultMap = stockService.getAllStocksWithPaging(page, size);
        List<StockInfoDTO> stockInfoList = (List<StockInfoDTO>) resultMap.get("results");
        long totalCount = (long) resultMap.get("totalCount");

        int totalPages = (int) Math.ceil((double) totalCount / size);

        // 코스피, 코스닥 종목 수 계산
        long kospiCount = stockService.countStocksByMarketType("KOSPI");
        long kosdaqCount = stockService.countStocksByMarketType("KOSDAQ");

        // 시장 요약 정보 조회
        MarketSummary marketSummary = stockService.getMarketSummary();



        model.addAttribute("stockInfoList", stockInfoList);
        model.addAttribute("kospiCount", kospiCount);
        model.addAttribute("kosdaqCount", kosdaqCount);
        model.addAttribute("marketSummary", marketSummary);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);

        return "analysis";
    }

    /**
     * 종목 검색 결과를 처리하는 메소드
     */
    @GetMapping("/search")
    public String searchStocks(
            @RequestParam("keyword") String keyword,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            Model model) {

        logger.debug("/stock/search 요청 - 키워드: {}, 페이지: {}, 크기: {}", keyword, page, size);


        Map<String, Object> resultMap;
        long totalCount;
        if (keyword == null || keyword.isBlank()) {
            // 빈 검색이면 전체 목록 반환
            resultMap = stockService.getAllStocksWithPaging(page, size);
            List<StockInfoDTO> tmpResultMap = stockService.getAllStocks();
            totalCount = (long) tmpResultMap.size();
        } else {
            // 검색어로 페이징 처리된 결과 반환
            resultMap = stockService.searchStocksWithPaging(keyword, page, size);
            totalCount = (long) resultMap.get("totalCount");
        }

        List<StockInfoDTO> stockInfoList = (List<StockInfoDTO>) resultMap.get("results");

        logger.debug("stockInfoList  {} ", stockInfoList);


        int totalPages = (int) Math.ceil((double) totalCount / size);

        // 시장 요약 정보 조회
        MarketSummary marketSummary = stockService.getMarketSummary();

        model.addAttribute("stockInfoList", stockInfoList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("searchKeyword", keyword);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("marketSummary", marketSummary);

        return "stockinfo";
    }


//    @GetMapping("/stock/search")
//    public Object searchStocks(
//            @RequestParam(value = "keyword", required = false) String keyword,
//            @RequestParam(value = "page", defaultValue = "1") int page,
//            @RequestParam(value = "size", defaultValue = "10") int size,
//            HttpServletRequest request,
//            Model model) {
//
//        // AJAX 요청인지 확인
//        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
//
//        // 검색 로직 수행
//        List<StockInfoDTO> stockInfoList = stockService.searchStocks(keyword, page, size);
//        int totalPages = stockService.getTotalPages(keyword, size);
//
//        if (isAjax) {
//            // AJAX 요청인 경우 JSON 응답
//            Map<String, Object> response = new HashMap<>();
//            response.put("success", true);
//            response.put("stockInfoList", stockInfoList);
//            response.put("currentPage", page);
//            response.put("totalPages", totalPages);
//            return ResponseEntity.ok(response);
//        } else {
//            // 일반 요청인 경우 뷰 리턴
//            model.addAttribute("stockInfoList", stockInfoList);
//            model.addAttribute("currentPage", page);
//            model.addAttribute("totalPages", totalPages);
//            return "stock/search";
//        }
//    }


    /**
     * 종목 검색 결과를 처리하는 메소드
     */
    @GetMapping("/get-favorites")
    @ResponseBody
    public Map<String, Object> getFavoriteStocks(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        logger.debug("/stock/get-favorites 요청 -");

        Map<String, Object> requestMap = new HashMap<>();
        String tmpUserId = "youngbeen";

        // 페이징 정보 추가
        requestMap.put("page", page);
        requestMap.put("size", size);
        requestMap.put("userId", tmpUserId);

        List<StockInfoDTO> resultArray = stockService.searchStockfavorites(requestMap);

        logger.debug("resultArray {} :::", resultArray);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("favorites", resultArray);
        response.put("currentPage", page);
        response.put("pageSize", size);

        return response;
    }

    /**
     * 주식 성과 비교를 처리하는 메소드
     */
    @GetMapping("/performance")
    @ResponseBody
    public Map<String, Object> getPerformance(
            @RequestParam(value = "marketType", required = false) String marketType,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            HttpSession session,
            Model model) {
        logger.debug("/stock/performance 요청 -");

        Map<String, Object> requestMap = new HashMap<>();
        // 페이징 정보 추가
        requestMap.put("marketType", marketType);
        requestMap.put("startDate", startDate);
        requestMap.put("endDate", endDate);

        Map<String, Object> resultMap = new HashMap<>();
        List<StockInfoDTO> resultArray = null;
        resultMap = (HashMap) stockService.getPerformance(requestMap);

        if(!resultMap.isEmpty()){
            resultArray = (List<StockInfoDTO>) resultMap.get("results");
        }

        logger.debug("resultArray {} :::", resultArray);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", resultArray);

        return response;
    }


    /**
     * 종목 검색 결과를 처리하는 메소드
     */
    @GetMapping("/detail-search")
    public String searchStockDetails(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "stockCode", required = false) String stockCode,
            @RequestParam(value = "stockName", required = false) String stockName,
            @RequestParam(value = "marketType", required = false) String marketType,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "sector", required = false) String sector,
            HttpSession session,
            Model model) {

        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("stockCode", stockCode);
        requestMap.put("stockName", stockName);
        requestMap.put("marketType", marketType);
        requestMap.put("startDate", startDate);
        requestMap.put("endDate", endDate);
        requestMap.put("sector", sector);

        // 페이징 정보 추가
        requestMap.put("page", page);
        requestMap.put("size", size);

        logger.debug("/stock/detail-search 요청 - 페이지: {}, 크기: {}", page, size);

        // 페이징된 결과와 총 개수를 함께 반환하는 메서드로 수정 필요
        Map<String, Object> resultMap = stockService.searchStockDetailsWithPaging(requestMap);

        List<StockInfoDTO> detailSearchResults = (List<StockInfoDTO>) resultMap.get("results");
        logger.debug("detailSearchResults :: {} ", detailSearchResults.size() > 0 ? detailSearchResults.get(0) : "데이터 없음");

        List<StockInfoDTO> allDetailSearchResults = stockService.searchStockDetails(requestMap);

        // JSON으로 변환 (JavaScript에서 사용하기 위함)
        String allDetailSearchResultsJson = "";
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            allDetailSearchResultsJson = objectMapper.writeValueAsString(allDetailSearchResults);
        } catch (Exception e) {
            logger.error("JSON 변환 중 오류 발생", e);
        }

        long totalCount = (long) resultMap.get("totalCount");
        // 총 페이지 수 계산
        int totalPages = (int) Math.ceil((double) totalCount / size);

        // 시장 요약 정보 조회
        MarketSummary marketSummary = stockService.getMarketSummary();

        // 세션에 검색 결과 저장
        session.setAttribute("fullSearchResults", detailSearchResults);

        model.addAttribute("detailSearchResults", detailSearchResults);
        model.addAttribute("allDetailSearchResultsJson", allDetailSearchResultsJson);
        model.addAttribute("detailTotalPages", totalPages > 0 ? totalPages : 1);
        model.addAttribute("detailCurrentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("marketSummary", marketSummary);

        return "analysis";
    }

    @PostMapping("/analysis")
    public ResponseEntity<Map<String, Object>> analyzeStockData(@RequestBody List<StockInfoDTO> stockDataList) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 데이터 유효성 검증
            if (stockDataList == null || stockDataList.isEmpty()) {
                response.put("message", "분석 실패");
                response.put("errorMessage", "분석할 데이터가 없습니다.");
                return ResponseEntity.badRequest().body(response);  // 400 Bad Request
            }

            logger.info("분석 요청 데이터 수: {}", stockDataList.size());
            logger.debug("분석 요청 데이터: {}", stockDataList);  // 민감한 정보는 debug 레벨로

            // 분석 서비스 호출 - 데이터를 직접 전달
            Map<String, Object> requestMap = new HashMap<>();
            requestMap.put("data", stockDataList);
            Map<String, Object> analysisResult = stockService.analyzeStockData(requestMap);

            // 성공 응답
            response.put("message", "분석 성공");
            response.put("count", stockDataList.size());
            response.put("result", analysisResult);
            //response.put("redirectUrl", "/stock/analysis-result");

            return ResponseEntity.ok(response);  // 200 OK

        } catch (Exception e) {
            logger.error("데이터 분석 중 오류 발생", e);
            response.put("message", "분석 실패");
            response.put("errorMessage", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);  // 500 Internal Server Error
        }
    }

    @PostMapping("/add-favorite")
    @ResponseBody
    public Map<String, Object> addFavorite(@RequestBody Map<String, String> request) {
        String stockCode = request.get("stockCode");
        String userId = "youngbeen"; // 임시 사용자 ID

        Map<String, Object> response = new HashMap<>();
        response.put("srtnCd", stockCode);
        response.put("userId", userId);

        logger.debug("addFavorite Controller 탐 Map : {}", response);

        try {
            // 즐겨찾기 추가 로직 구현
            stockService.addFavoriteStock(response);

            response.put("success", true);
            response.put("message", "즐겨찾기에 추가되었습니다.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return response;
    }

    @PostMapping("/delete-favorite")
    @ResponseBody
    public Map<String, Object> deleteFavorite(@RequestBody Map<String, String> request) {
        String stockCode = request.get("stockCode");
        String userId = "youngbeen"; // 임시 사용자 ID

        Map<String, Object> response = new HashMap<>();
        response.put("srtnCd", stockCode);
        response.put("userId", userId);

        logger.debug("deleteFavorite Controller 탐 Map : {}", response);

        try {
            // 즐겨찾기 추가 로직 구현
            stockService.deleteFavoriteStock(response);

            response.put("success", true);
            response.put("message", "즐겨찾기에서 삭제되었습니다.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return response;
    }

}
