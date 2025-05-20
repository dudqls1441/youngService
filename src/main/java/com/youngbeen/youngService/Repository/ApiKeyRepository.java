package com.youngbeen.youngService.Repository;

import com.youngbeen.youngService.Entity.ApiKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface ApiKeyRepository extends JpaRepository<ApiKey, Long> {
    Optional<ApiKey> findByKeyValueAndActiveTrue(String keyValue);

    List<ApiKey> findAllByActive(Integer active);

    Optional<ApiKey> findByKeyValue(String keyValue);

    // validateApiKey 메소드에서 사용할 메소드
    Optional<ApiKey> findByKeyValueAndActive(String keyValue, Integer active);

    // 활성화된 모든 API 키 조회 (API 키 관리 페이지에서 사용)
    List<ApiKey> findAllByActiveTrue();

}
