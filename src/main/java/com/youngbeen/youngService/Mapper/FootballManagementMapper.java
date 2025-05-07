package com.youngbeen.youngService.Mapper;

import com.youngbeen.youngService.DTO.StockInfoDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;
import java.util.Optional;


@Mapper
public interface FootballManagementMapper {
    /**
     * 종목명이나 코드로 검색
     */
    List<Map> findAllPlayer(Map map);

    /**
     * 선수 정보 등록
     * @param playerInfo 선수 정보
     * @return 영향 받은 행 수
     */
    int insertPlayer(Map<String, Object> playerInfo);

    /**
     * 선수 평가 정보 등록
     * @param ratingInfo 선수 평가 정보
     * @return 영향 받은 행 수
     */
    int insertPlayerRating(Map<String, Object> ratingInfo);

    /**
     * 선수 평가 정보 삭제
     * @param params 선수 ID를 포함한 파라미터
     * @return 삭제된 레코드 수
     */
    int deletePlayerRating(Map<String, Object> params);

    /**
     * 선수 정보 삭제
     * @param params 선수 ID를 포함한 파라미터
     * @return 삭제된 레코드 수
     */
    int deletePlayer(Map<String, Object> params);

}
