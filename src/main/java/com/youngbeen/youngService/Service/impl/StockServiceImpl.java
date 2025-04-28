package com.youngbeen.youngService.Service.impl;

import com.youngbeen.youngService.DTO.StockInfoDTO;
import com.youngbeen.youngService.Mapper.BookmarkMapper;
import com.youngbeen.youngService.Mapper.MarketSummary;
import com.youngbeen.youngService.Mapper.StockInfoMapper;
import com.youngbeen.youngService.Service.StockService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StockServiceImpl implements StockService {

    @Value("${weather.api.key}")
    private String apiKey;

    private final StockInfoMapper stockInfoMapper;

    private static final Logger logger = LoggerFactory.getLogger(StockServiceImpl.class);


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
    public long countStocksByMarketType(String marketType) {
        return stockInfoMapper.countByMarketType(marketType);
    }


    @Override
    public MarketSummary getMarketSummary() {
        // 실제 구현에서는 외부 API나 DB에서 정보를 가져옴
        // 예제를 위한 임시 데이터

        return null;
    }

/*        return MarketSummary.builder()
                .kospiIndex(3150.48)
                .kospiChange(0.85)
                .kosdaqIndex(928.76)
                .kosdaqChange(-0.32)
                .updateTime(LocalDateTime.now())
                .build();
    }*/

}