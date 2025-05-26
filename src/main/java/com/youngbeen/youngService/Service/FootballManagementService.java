package com.youngbeen.youngService.Service;


import java.util.List;
import java.util.Map;

public interface FootballManagementService {

    /**
     * 모든 선수 정보 조회
     * @return 선수 정보 목록
     */
    List<Map> getPlayers(Map map);

    /**
     * 한 선수의 정보 조회 (최근 5주 데이터)
     * @return 선수 정보 목록
     */
    List<Map<String, Object>> getPlayerData(Map<String, Object> params);


    /**
     * 기본 평가(가중치 5)와 최근 평가 평균(가중치 5)을 합산하여 선수 평균치 도출
     * @return 선수 정보 목록
     */
    List<Map<String, Object>> getPlayerAverageRatings();

    /**
     * 매치 날짜 조회
     * @return 매치 날짜 목록
     */
    List<Map> getMatchSchedules();

    /**
     * 신규 선수 및 평가 등록
     * @param playerInfo 선수 정보 및 평가 정보
     * @return 등록 성공 여부
     */
    Map<String, Object> registerNewPlayer(Map<String, Object> playerInfo);

    /**
     * 선수 삭제
     * @return 등록 성공 여부
     */
    void deletePlayer(long playerId);

    int saveAllPlayerRatings(Map<String, Object> scheduleInfo, List<Map<String, Object>> playerRatings);

    /**
     * ML/DL 기반 팀 밸런싱 수행
     * @param requestMap 요청 데이터 (players, teamCount, algorithm)
     * @return 팀 밸런싱 결과
     */
    Map<String, Object> balanceTeamsWithML(Map<String, Object> requestMap);

    List<Map<String, Object>> getPreviousWeekRatings(Integer scheduleId);

    Long getPlayerIdByName(String name);
}
