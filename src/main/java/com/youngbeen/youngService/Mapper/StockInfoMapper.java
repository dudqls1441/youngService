package com.youngbeen.youngService.Mapper;

import com.youngbeen.youngService.DTO.StockInfoDTO;
import org.apache.ibatis.annotations.Mapper;

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
}
