package com.youngbeen.youngService.Service.impl;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.youngbeen.youngService.DTO.StockInfoDTO;
import com.youngbeen.youngService.Mapper.MarketSummary;
import com.youngbeen.youngService.Mapper.StockInfoMapper;
import com.youngbeen.youngService.Service.StockService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.BufferedReader;
import java.io.InputStreamReader;

@Service
public class StockServiceImpl implements StockService {

    @Value("${weather.api.key}")
    private String apiKey;

    private final StockInfoMapper stockInfoMapper;

    private static final Logger logger = LoggerFactory.getLogger(StockServiceImpl.class);

    @Value("${python.script.path}")
    private String pythonScriptPath;

    @Value("${python.executable}")
    private String pythonExecutable;

    @Value("${analysis.results.dir}")
    private String analysisResultsDir;

    @Autowired
    private ObjectMapper objectMapper;


    @Autowired
    public StockServiceImpl(StockInfoMapper stockInfoMapper) {
        this.stockInfoMapper = stockInfoMapper;
    }

    @Override
    public List<StockInfoDTO> getAllStocks() {
        logger.info("모든 주식 정보 조회");
        return stockInfoMapper.findAll();
    }

    @Override
    public void addFavoriteStock(Map map) {
        logger.info("주식 즐겨찾기 추가 addFavoriteStock map {} :",map);
        stockInfoMapper.addFavoriteStock(map);
    }

    @Override
    public void deleteFavoriteStock(Map map) {
        logger.info("주식 즐겨찾기 추가 deleteFavoriteStock map {} :",map);
        stockInfoMapper.deleteFavoriteStock(map);
    }

    @Override
    public Map<String, Object> getAllStocksWithPaging(int page, int size) {
        logger.info("모든 주식 정보 페이징 조회: 페이지={}, 크기={}", page, size);

        Map<String, Object> result = new HashMap<>();

        // 전체 데이터 수 조회
        long totalCount = stockInfoMapper.countAll();

        // 오프셋 계산 (0부터 시작하는 인덱스)
        int offset = (page - 1) * size;


        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("limit", size);
        paramMap.put("offset", offset);

        // 페이징된 데이터 조회
        List<StockInfoDTO> pagedResults = stockInfoMapper.findAllWithPaging(paramMap);

        result.put("results", pagedResults);
        result.put("totalCount", totalCount);

        return result;
    }

    @Override
    public List<StockInfoDTO> searchStocks(String keyword) {
        logger.info("키워드로 주식 검색: {}", keyword);
        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        return stockInfoMapper.findByStockNameContainingIgnoreCaseOrStockCodeContainingIgnoreCase(keyword.trim());
    }

    @Override
    public Map<String, Object> searchStocksWithPaging(String keyword, int page, int size) {
        logger.info("키워드로 주식 페이징 검색: {}, 페이지={}, 크기={}", keyword, page, size);

        Map<String, Object> result = new HashMap<>();

        if (keyword == null || keyword.trim().isEmpty()) {
            // 키워드가 없는 경우 빈 결과 반환
            result.put("results", Collections.emptyList());
            result.put("totalCount", 0L);
            return result;
        }

        // 검색 조건에 맞는 전체 데이터 수 조회
        long totalCount = stockInfoMapper.countByKeyword(keyword.trim());

        // 오프셋 계산
        int offset = (page - 1) * size;

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("keyword", keyword.trim());
        paramMap.put("limit", size);
        paramMap.put("offset", offset);

        // 페이징된 검색 결과 조회
        List<StockInfoDTO> pagedResults = stockInfoMapper.findByKeywordWithPaging(paramMap);

        result.put("results", pagedResults);
        result.put("totalCount", totalCount);

        return result;
    }

    @Override
    public List<StockInfoDTO> searchStockDetails(Map map) {
        logger.info("키워드로 주식 상세 검색: {}", map);

        return stockInfoMapper.searchStockDetails(map);
    }

    @Override
    public List<StockInfoDTO> searchStockfavorites(Map map) {
        logger.info("즐겨찾기 종목 검색: {}", map);

        return stockInfoMapper.searchStockfavorites(map);
    }

    @Override
    public Map<String, Object> searchStockDetailsWithPaging(Map<String, Object> map) {
        logger.info("주식 상세 페이징 검색: {}", map);

        Map<String, Object> result = new HashMap<>();

        // 페이지 정보 추출
        int page = map.containsKey("page") ? Integer.parseInt(map.get("page").toString()) : 1;
        int size = map.containsKey("size") ? Integer.parseInt(map.get("size").toString()) : 10;

        // 오프셋 계산
        int offset = (page - 1) * size;

        // Map에 페이징 정보 추가
        map.put("offset", offset);
        map.put("limit", size);

        // 상세 검색 조건에 맞는 전체 데이터 수 조회
        long totalCount = stockInfoMapper.countStockDetailsWithConditions(map);

        // 페이징된 검색 결과 조회
        List<StockInfoDTO> pagedResults = stockInfoMapper.searchStockDetailsWithPaging(map);

        result.put("results", pagedResults);
        result.put("totalCount", totalCount);

        return result;
    }


    @Override
    public Map<String, Object> getPerformance(Map<String, Object> map) {
        logger.debug("map ::{}",map);

        Map<String, Object> result = new HashMap<>();

        // 페이징된 검색 결과 조회
        List<StockInfoDTO> pagedResults = stockInfoMapper.selcetPerformance(map);

        result.put("results", pagedResults);

        return result;
    }


    @Override
    public Map<String, Object> analyzeStockData(Map<String, Object> map) {
        try {
            List<StockInfoDTO> responseData = (List<StockInfoDTO>) map.get("data");
            logger.debug("responseData : {}", responseData);

            // Flask API로 데이터 전송하여 분석 결과 받기
            Map<String, Object> result = executeFlaskAnalysis(responseData);
            return result;

        } catch (Exception e) {
            logger.error("주식 데이터 분석 중 오류 발생", e);
            return Map.of("status", "error", "message", e.getMessage());
        }
    }


    private Map<String, Object> executeFlaskAnalysis(List<StockInfoDTO> stockData) throws Exception {
        logger.info("Flask API를 통한 주식 데이터 분석 시작");

        // Flask 서버 URL 설정
        //String flaskApiUrl = "http://192.168.136.128:5000/analyze-stock1"; // 환경 설정으로 관리할 수 있음
        String flaskApiUrl = "http://192.168.136.128:5000/analyze-stock2"; // 환경 설정으로 관리할 수 있음

        // HTTP 클라이언트 생성
        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();

        // 데이터를 JSON으로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonData = objectMapper.writeValueAsString(stockData);

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
            throw new RuntimeException("Python 분석 API 호출 실패. 상태 코드: " + statusCode);
        }

        // 응답 본문을 Map으로 변환
        Map<String, Object> result = objectMapper.readValue(response.body(), new TypeReference<Map<String, Object>>() {});

        logger.info("Flask API를 통한 주식 데이터 분석 완료");
        logger.debug("분석 결과: {}", result);

        return result;
    }

    @Override
    public long countStocksByMarketType(String marketType) {
        return stockInfoMapper.countByMarketType(marketType);
    }


    @Override
    public MarketSummary getMarketSummary() {
        // 실제 구현에서는 외부 API나 DB에서 정보를 가져옴
        // 예제를 위한 임시 데이터

        return null;
    }
}