package com.youngbeen.youngService.Mapper;

import com.youngbeen.youngService.DTO.StockInfoDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;
import java.util.Map;
import java.util.Optional;


@Mapper
public interface StockInfoMapper {
    /**
     * 종목명이나 코드로 검색
     */
    List<StockInfoDTO> findAll();

    /**
     * 종목명이나 코드로 검색
     */
    List<StockInfoDTO> findByStockNameContainingIgnoreCaseOrStockCodeContainingIgnoreCase(String stockCode);

    /**
     * 종목명이나 코드로 상세 검색
     */
    List<StockInfoDTO> searchStockDetails(Map map);

    /**
     * 종목 코드로 상세 정보 조회
     */
    Optional<StockInfoDTO> findByStockCode(String stockCode);

    /**
     * 시장 유형별 종목 수 조회
     */
    long countByMarketType(String marketType);

    //페이징 처리된 전체 주식 목록 조회
    // 페이징된 검색 결과 조회


    // 즐겨찾기
    List<StockInfoDTO> searchStockfavorites(Map map);

    /**
     * 전체 데이터 수 조회
     */
    long countAll();

    List<StockInfoDTO> findAllWithPaging(Map map);

    List<StockInfoDTO> findByKeywordWithPaging(Map map);

    // 페이징된 검색 결과 조회
    // 검색 조건에 맞는 전체 데이터 수
    List<StockInfoDTO> searchStockDetailsWithPaging(Map map);

    List<StockInfoDTO> selcetPerformance(Map map);

    long countByKeyword(String keyword);

    // 상세 검색 조건으로 검색된 주식 데이터 수 조회
    long countStockDetailsWithConditions(Map map);

    void addFavoriteStock(Map map);

    void deleteFavoriteStock(Map map);


    // 전체 레코드 수 조회
    @Select("SELECT COUNT(*) FROM STOCK_PRICE")
    long getTotalCount();

    // 배치 단위로 데이터 조회 (BASDT별로)
    @Select("SELECT DISTINCT BASDT FROM STOCK_PRICE ORDER BY BASDT LIMIT #{limit} OFFSET #{offset}")
    List<String> getBasDtBatch(@Param("offset") long offset, @Param("limit") int limit);

    // 특정 BASDT의 모든 레코드 업데이트
    @Update("UPDATE STOCK_PRICE SET REMARKS = #{remarks} WHERE BASDT = #{basDt}")
    int updateRemarksByBasDt(@Param("basDt") String basDt, @Param("remarks") String remarks);

    // 특정 BASDT의 레코드 수 조회
    @Select("SELECT COUNT(*) FROM STOCK_PRICE WHERE BASDT = #{basDt}")
    long getCountByBasDt(@Param("basDt") String basDt);

    // 진행상황 확인용 - 업데이트된 레코드 수
    @Select("SELECT COUNT(*) FROM STOCK_PRICE WHERE REMARKS IS NOT NULL AND REMARKS != ''")
    long getUpdatedCount();

    // 배치 업데이트 (더 효율적인 방법)
    @Update("UPDATE STOCK_PRICE SET REMARKS = BASDT WHERE REMARKS IS NULL OR REMARKS = ''")
    int updateAllRemarksWithBasDt();

    /**
     * 모든 REMARKS를 NULL로 초기화
     */
    int resetAllRemarksToNull();

    /**
     * 배치 단위로 REMARKS를 NULL로 초기화
     * @param offset 시작 위치
     * @param batchSize 배치 크기
     * @return 초기화된 레코드 수
     */
    int resetRemarksBatch(@Param("offset") long offset, @Param("batchSize") int batchSize);
}
