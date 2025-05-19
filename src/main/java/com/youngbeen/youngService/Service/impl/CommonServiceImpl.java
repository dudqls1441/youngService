package com.youngbeen.youngService.Service.impl;

import com.youngbeen.youngService.Service.CommonService;
import org.springframework.stereotype.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;


@Service
public class CommonServiceImpl implements CommonService {
    private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

    @Value("${file.upload-dir}")
    private String uploadDir;

    // 실제 API URL은 환경에 맞게 application.properties 또는 application.yml에 설정
    @Value("${api.university.base-url:https://api.example.com/universities}")
    private String baseUrl;

    @Value("${api.university.api-key:}")
    private String apiKey;

    private final RestTemplate restTemplate;

    // 샘플 대학교 데이터 (실제 API 연동 전 테스트용)
    private static final List<Map<String, Object>> SAMPLE_UNIVERSITIES = new ArrayList<>();

    static {
        // 샘플 데이터 초기화
        Map<String, Object> univ1 = new HashMap<>();
        univ1.put("id", "1");
        univ1.put("name", "서울대학교");
        univ1.put("address", "서울특별시 관악구 관악로 1");
        univ1.put("type", "국립");
        univ1.put("website", "https://www.snu.ac.kr");

        Map<String, Object> univ2 = new HashMap<>();
        univ2.put("id", "2");
        univ2.put("name", "연세대학교");
        univ2.put("address", "서울특별시 서대문구 연세로 50");
        univ2.put("type", "사립");
        univ2.put("website", "https://www.yonsei.ac.kr");

        Map<String, Object> univ3 = new HashMap<>();
        univ2.put("id", "3");
        univ2.put("name", "안양대학교");
        univ2.put("address", "경기도 안양시 만안구");
        univ2.put("type", "사립");
        univ2.put("website", "https://www.anyang.ac.kr");

        SAMPLE_UNIVERSITIES.add(univ1);
        SAMPLE_UNIVERSITIES.add(univ2);
        SAMPLE_UNIVERSITIES.add(univ3);

    }

    public CommonServiceImpl(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @Override
    public List<Map<String, Object>> searchUniversities(String keyword) {
        logger.info("대학교 검색: keyword={}", keyword);

        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        try {
            // 실제 API 연동 시 사용할 코드
            /*
            String url = UriComponentsBuilder.fromHttpUrl(baseUrl + "/search")
                    .queryParam("keyword", keyword)
                    .queryParam("apiKey", apiKey)
                    .build()
                    .toUriString();

            ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                return (List<Map<String, Object>>) response.getBody().get("data");
            }
            */

            // 샘플 데이터 필터링 (실제 API 연동 전 테스트용)
            return SAMPLE_UNIVERSITIES.stream()
                    .filter(univ -> {
                        String name = (String) univ.get("name");
                        return name != null && name.contains(keyword);
                    })
                    .toList();

        } catch (Exception e) {
            logger.error("대학교 검색 API 호출 중 오류 발생", e);
            throw new RuntimeException("대학교 검색 API 호출 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }

    @Override
    public Map<String, Object> getUniversityDetails(String universityId) {
        logger.info("대학교 상세 정보 조회: universityId={}", universityId);

        if (universityId == null || universityId.trim().isEmpty()) {
            return Collections.emptyMap();
        }

        try {
            // 실제 API 연동 시 사용할 코드
            /*
            String url = UriComponentsBuilder.fromHttpUrl(baseUrl + "/details/" + universityId)
                    .queryParam("apiKey", apiKey)
                    .build()
                    .toUriString();

            ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);

            if (response.getStatusCode().isSuccessful() && response.getBody() != null) {
                return response.getBody();
            }
            */

            // 샘플 데이터 조회 (실제 API 연동 전 테스트용)
            return SAMPLE_UNIVERSITIES.stream()
                    .filter(univ -> universityId.equals(univ.get("id")))
                    .findFirst()
                    .orElse(Collections.emptyMap());

        } catch (Exception e) {
            logger.error("대학교 상세 정보 API 호출 중 오류 발생", e);
            throw new RuntimeException("대학교 상세 정보 API 호출 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }

    // 추가 메서드: 모든 대학교 목록 조회
    public List<Map<String, Object>> getAllUniversities() {
        logger.info("모든 대학교 목록 조회");

        try {
            // 실제 API 연동 시 사용할 코드
            /*
            String url = UriComponentsBuilder.fromHttpUrl(baseUrl + "/all")
                    .queryParam("apiKey", apiKey)
                    .build()
                    .toUriString();

            ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                return (List<Map<String, Object>>) response.getBody().get("data");
            }
            */

            // 샘플 데이터 반환 (실제 API 연동 전 테스트용)
            return new ArrayList<>(SAMPLE_UNIVERSITIES);

        } catch (Exception e) {
            logger.error("대학교 목록 API 호출 중 오류 발생", e);
            throw new RuntimeException("대학교 목록 API 호출 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }

    /**
     * 프로필 이미지 업로드
     */
    public String uploadProfileImage(MultipartFile file, String memberId) {
        try {
            // 파일 저장 경로 설정
            String profileDir = uploadDir + "/profiles/" + memberId;
            Path dirPath = Paths.get(profileDir);

            if (!Files.exists(dirPath)) {
                Files.createDirectories(dirPath);
            }

            File directory = dirPath.toFile();
            File[] existingFiles = directory.listFiles();
            if (existingFiles != null) {
                for (File existingFile : existingFiles) {
                    existingFile.delete();
                }
            }

            // 파일명 생성
            String originalFileName = file.getOriginalFilename();
            String fileExtension = "";
            if (originalFileName != null && originalFileName.contains(".")) {
                fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }
            String newFileName = UUID.randomUUID().toString() + fileExtension;

            // 파일 저장
            Path filePath = Paths.get(profileDir + "/" + newFileName);
            Files.copy(file.getInputStream(), filePath);

            // 상대 경로 반환 (웹에서 접근 가능한 URL)
            //return "/resources/profiles/" + memberId + "/" + newFileName;
            return "/resources/static/profile/" + newFileName;
        } catch (IOException e) {
            throw new RuntimeException("파일 업로드 중 오류가 발생했습니다.", e);
        }
    }


}
