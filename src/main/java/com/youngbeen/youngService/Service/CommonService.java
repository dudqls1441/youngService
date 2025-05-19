package com.youngbeen.youngService.Service;

import java.util.List;
import java.util.Map;

public interface CommonService {

    /**
     * 키워드로 대학교 정보 검색
     *
     * @param keyword 검색 키워드
     * @return 대학교 정보 목록
     */
    List<Map<String, Object>> searchUniversities(String keyword);

    /**
     * 대학교 ID로 상세 정보 조회
     *
     * @param universityId 대학교 ID
     * @return 대학교 상세 정보
     */
    Map<String, Object> getUniversityDetails(String universityId);
}
