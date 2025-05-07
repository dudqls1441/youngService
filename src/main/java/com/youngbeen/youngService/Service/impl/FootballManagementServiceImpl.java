package com.youngbeen.youngService.Service.impl;

import com.youngbeen.youngService.Mapper.FootballManagementMapper;
import com.youngbeen.youngService.Service.FootballManagementService;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class FootballManagementServiceImpl implements FootballManagementService {

    private static final Logger logger = LoggerFactory.getLogger(FootballManagementServiceImpl.class);

    private final FootballManagementMapper fmMapper;

    public FootballManagementServiceImpl(FootballManagementMapper fmMapper) {
        this.fmMapper = fmMapper;
    }

    @Override
    public List<Map> getPlayers(Map map) {
        logger.info("선수 정보 조회 getPlayers map {} :",map.get("Date"));

        List<Map> result = fmMapper.findAllPlayer(map);
        return result;
    }

    @Override
    @Transactional  // 트랜잭션 적용 (둘 다 성공하거나 둘 다 실패)
    public Map<String, Object> registerNewPlayer(Map<String, Object> playerInfo) {
        logger.info("신규 선수 등록 registerNewPlayer playerInfo: {}", playerInfo);

        Map<String, Object> result = new HashMap<>();
        try {
            // 1. 선수 정보 등록
            int playerInserted = fmMapper.insertPlayer(playerInfo);

            if (playerInserted > 0) {
                // 2. 생성된 player_id를 가져와서 선수 평가 정보에 설정
                Long playerId = (Long) playerInfo.get("playerId");

                // 선수 평가 정보 등록
                Map<String, Object> ratingInfo = new HashMap<>();
                ratingInfo.put("playerId", playerId);
                ratingInfo.put("attackScore", playerInfo.get("attackScore"));
                ratingInfo.put("defenseScore", playerInfo.get("defenseScore"));
                ratingInfo.put("staminaScore", playerInfo.get("staminaScore"));
                ratingInfo.put("speedScore", playerInfo.get("speedScore"));
                ratingInfo.put("techniqueScore", playerInfo.get("techniqueScore"));
                ratingInfo.put("teamworkScore", playerInfo.get("teamworkScore"));

                int ratingInserted = fmMapper.insertPlayerRating(ratingInfo);

                if (ratingInserted > 0) {
                    result.put("success", true);
                    result.put("message", "선수 정보가 성공적으로 등록되었습니다.");
                    result.put("playerId", playerId);
                } else {
                    throw new RuntimeException("선수 평가 정보 등록 실패");
                }
            } else {
                throw new RuntimeException("선수 정보 등록 실패");
            }
        } catch (Exception e) {
            logger.error("선수 등록 중 오류 발생: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "선수 등록 중 오류가 발생했습니다: " + e.getMessage());
        }

        return result;
    }

    @Override
    public void deletePlayer(long playerId) {
        logger.info("선수 삭제 deletePlayer playerId: {}", playerId);

        // 1. 선수 평가 정보 먼저 삭제 (외래 키 제약조건 때문)
        Map<String, Object> params = new HashMap<>();
        params.put("playerId", playerId);

        int ratingDeleted = fmMapper.deletePlayerRating(params);
        logger.debug("선수 평가 정보 삭제 결과: {}", ratingDeleted);

        // 2. 선수 정보 삭제
        int playerDeleted = fmMapper.deletePlayer(params);
        logger.debug("선수 정보 삭제 결과: {}", playerDeleted);

        // 삭제된 레코드가 없으면 예외 발생
        if (playerDeleted == 0) {
            throw new RuntimeException("삭제할 선수 정보가 존재하지 않습니다: " + playerId);
        }
    }
}
