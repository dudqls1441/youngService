package com.youngbeen.youngService.Service.impl;

import com.youngbeen.youngService.Entity.ApiKey;
import com.youngbeen.youngService.Repository.ApiKeyRepository;
import com.youngbeen.youngService.Service.ApiKeyService;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class ApiServcieImpl implements ApiKeyService {

    private static final Logger logger = LoggerFactory.getLogger(ApiServcieImpl.class);

    private final ApiKeyRepository apiKeyRepository;

    public ApiServcieImpl(ApiKeyRepository apiKeyRepository) {
        this.apiKeyRepository = apiKeyRepository;
    }


    /**
     * API 키 유효성 검증
     */
    @Override
    public boolean isValidApiKey(String keyValue) {
        Optional<ApiKey> apiKeyOpt = apiKeyRepository.findByKeyValueAndActiveTrue(keyValue);

        if (apiKeyOpt.isPresent()) {
            // 마지막 사용 시간 업데이트
            ApiKey apiKey = apiKeyOpt.get();
            apiKey.setLastUsedAt(LocalDateTime.now());
            apiKeyRepository.save(apiKey);
            return true;
        }

        return false;
    }

    /**
     * API 키 유효성 검증 (IP 주소 확인 포함)
     */
    @Override
    public boolean isValidApiKey(String keyValue, String ipAddress) {
        Optional<ApiKey> apiKeyOpt = apiKeyRepository.findByKeyValueAndActiveTrue(keyValue);

        if (apiKeyOpt.isPresent()) {
            ApiKey apiKey = apiKeyOpt.get();

            // IP 제한이 설정되어 있는 경우 확인
            if (apiKey.getAllowedIps() != null && !apiKey.getAllowedIps().isEmpty()) {
                String[] allowedIps = apiKey.getAllowedIps().split(",");

                logger.debug("allowedIps::{}",allowedIps);
                boolean ipAllowed = false;

                for (String allowedIp : allowedIps) {
                    if (allowedIp.trim().equals(ipAddress)) {
                        ipAllowed = true;
                        break;
                    }
                }

                if (!ipAllowed) {
                    return false;
                }
            }

            // 마지막 사용 시간 업데이트
            apiKey.setLastUsedAt(LocalDateTime.now());
            apiKeyRepository.save(apiKey);
            return true;
        }

        return false;
    }

    /**
     * 새 API 키 생성
     */
    @Transactional
    @Override
    public ApiKey generateApiKey(String clientName, String description) {
        String keyValue = UUID.randomUUID().toString().replace("-", "");

        ApiKey apiKey = new ApiKey();
        apiKey.setKeyValue(keyValue);
        apiKey.setClientName(clientName);
        apiKey.setDescription(description);
        apiKey.setActive(true);

        return apiKeyRepository.save(apiKey);
    }

    /**
     * API 키 비활성화
     */
    @Transactional
    @Override
    public boolean deactivateApiKey(String keyValue) {
        Optional<ApiKey> apiKeyOpt = apiKeyRepository.findByKeyValueAndActiveTrue(keyValue);

        if (apiKeyOpt.isPresent()) {
            ApiKey apiKey = apiKeyOpt.get();
            apiKey.setActive(false);
            apiKeyRepository.save(apiKey);
            return true;
        }

        return false;
    }


    /**
     * 모든 활성 API 키 조회
     */
    @Override
    public List<ApiKey> getAllActiveApiKeys() {
        return apiKeyRepository.findAll().stream()
                .filter(ApiKey::isActive)
                .toList();
    }

    /**
     * 허용 IP 주소 설정
     */
    @Transactional
    @Override
    public boolean updateAllowedIps(String keyValue, String allowedIps) {
        Optional<ApiKey> apiKeyOpt = apiKeyRepository.findByKeyValueAndActiveTrue(keyValue);

        if (apiKeyOpt.isPresent()) {
            ApiKey apiKey = apiKeyOpt.get();
            apiKey.setAllowedIps(allowedIps);
            apiKeyRepository.save(apiKey);
            return true;
        }

        return false;
    }

    /**
     * API 키 유효성 검증 (클라이언트 IP 포함)
     */
    public boolean validateApiKey(String keyValue, String clientIp) {
        // 1. API 키 존재 여부 확인 및 활성 상태 확인
        ApiKey apiKey = apiKeyRepository.findByKeyValueAndActive(keyValue, 1)
                .orElse(null);

        if (apiKey == null) {
            return false;
        }

        // 2. 허용 IP 체크 (허용 IP가 설정되어 있는 경우)
        if (apiKey.getAllowedIps() != null && !apiKey.getAllowedIps().isEmpty()) {
            String[] allowedIps = apiKey.getAllowedIps().split(",");
            boolean ipAllowed = false;

            for (String ip : allowedIps) {
                if (ip.trim().equals(clientIp)) {
                    ipAllowed = true;
                    break;
                }
            }

            if (!ipAllowed) {
                return false;
            }
        }

        return true;
    }

    /**
     * API 키 사용 기록 업데이트
     */
    public void updateApiKeyUsage(String keyValue, String endpoint) {
        ApiKey apiKey = apiKeyRepository.findByKeyValue(keyValue)
                .orElse(null);

        if (apiKey != null) {
            apiKey.setLastUsedAt(LocalDateTime.now());
            apiKeyRepository.save(apiKey);

            // API 사용 로그 저장 (필요한 경우)
            // apiKeyLogRepository.save(new ApiKeyLog(apiKey, endpoint, LocalDateTime.now()));
        }
    }

}
