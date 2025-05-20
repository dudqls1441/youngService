package com.youngbeen.youngService.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class ApiKeyInterceptor implements HandlerInterceptor {

    private final ApiKeyService apiKeyService;

    @Autowired
    public  ApiKeyInterceptor(ApiKeyService apiKeyService){
        this.apiKeyService = apiKeyService;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws IOException {
        // API 경로에만 적용
        if (request.getRequestURI().startsWith("/api/v1/")) {
            // API 키 파라미터 확인
            String apiKey = request.getParameter("apiKey");

            // API 키가 없는 경우
            if (apiKey == null || apiKey.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"API 키가 필요합니다.\",\"data\":null}");
                return false;
            }

            // API 키 유효성 검증 (클라이언트 IP 포함)
            String clientIp = request.getRemoteAddr();
            boolean isValid = apiKeyService.validateApiKey(apiKey, clientIp);

            if (!isValid) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"유효하지 않은 API 키이거나 허용되지 않은 IP입니다.\",\"data\":null}");
                return false;
            }

            // API 키 사용 기록 업데이트 (비동기로 처리하는 것이 좋음)
            apiKeyService.updateApiKeyUsage(apiKey, request.getRequestURI());
        }

        return true;
    }
}
