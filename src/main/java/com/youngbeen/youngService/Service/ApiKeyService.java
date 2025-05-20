package com.youngbeen.youngService.Service;

import com.youngbeen.youngService.Entity.ApiKey;

import java.util.List;

public interface ApiKeyService {

    /**
     * API 키 유효성 검증
     */
    boolean isValidApiKey(String keyValue);

    /**
     * API 키 유효성 검증 (IP 주소 확인 포함)
     */
    boolean isValidApiKey(String keyValue, String ipAddress);

    /**
     * 새 API 키 생성
     */
    ApiKey generateApiKey(String clientName, String description);

    /**
     * API 키 비활성화
     */
    boolean deactivateApiKey(String keyValue);

    /**
     * 모든 활성 API 키 조회
     */
    List<ApiKey> getAllActiveApiKeys();

    /**
     * 허용 IP 주소 설정
     */
    boolean updateAllowedIps(String keyValue, String allowedIps);

    /**
     * API 키 유효성 검증 (클라이언트 IP 포함)
     */
    boolean validateApiKey(String apiKey,String clientIp);

    /**
     * API 키 사용 기록 업데이트
     */
    void updateApiKeyUsage(String apiKey, String uri);




}
