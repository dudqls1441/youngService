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
}
