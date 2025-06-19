package com.youngbeen.youngService.Service;

import com.youngbeen.youngService.DTO.StockInfoDTO;
import com.youngbeen.youngService.Mapper.MarketSummary;

import java.util.List;
import java.util.Map;

public interface StockService {

    /**
     * 모든 주식 정보를 조회
     * @return 주식 정보 목록
     */
    List<StockInfoDTO> getAllStocks();

    /**
     * 주식 상세 검색
     * @param map 검색어(종목명 또는 코드)
     * @return 검색 결과 목록
     */
    List<StockInfoDTO> searchStockDetails(Map map);

    /**
     * 주식 정보  즐겨찾기
     * @param map 검색어(종목명 또는 코드)
     * @return 검색 결과 목록
     */
    List<StockInfoDTO> searchStockfavorites(Map map);

    /**
     * 주식 즐겨찾기 추가
     * @param map 검색어(종목명 또는 코드)
     * @return 검색 결과 목록
     */
    void addFavoriteStock(Map map);

    /**
     * 주식 즐겨찾기 삭제
     * @param map 검색어(종목명 또는 코드)
     * @return 검색 결과 목록
     */
    void deleteFavoriteStock(Map map);

    /**
     * 시장 유형별 종목 수 계산
     * @param marketType 시장 유형(KOSPI, KOSDAQ 등)
     * @return 해당 시장 유형의 종목 수
     */
    long countStocksByMarketType(String marketType);

    /**
     * 시장 요약 정보 조회
     * @return 시장 요약 정보
     */
    MarketSummary getMarketSummary();


    Map<String, Object> getAllStocksWithPaging(int page, int size, Map<String, Object> map);
    Map<String, Object> searchStocksWithPaging(String keyword, int page, int size, Map<String, Object> map);
    Map<String, Object> searchStockDetailsWithPaging(Map<String, Object> map);
    Map<String, Object> analyzeStockData(Map<String, Object> map);


    Map<String, Object> getPerformance(Map<String, Object> map);

}
