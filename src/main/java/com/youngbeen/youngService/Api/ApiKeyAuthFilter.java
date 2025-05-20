package com.youngbeen.youngService.Api;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.youngbeen.youngService.DTO.ApiResponse;
import com.youngbeen.youngService.Service.ApiKeyService;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.MediaType;

import java.io.IOException;


@Component
public class ApiKeyAuthFilter extends OncePerRequestFilter {

    private final ApiKeyService apiKeyService;
    private final ObjectMapper objectMapper;

    public ApiKeyAuthFilter(ApiKeyService apiKeyService, ObjectMapper objectMapper) {
        this.apiKeyService = apiKeyService;
        this.objectMapper = objectMapper;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        // API 경로에만 필터 적용
        String requestPath = request.getRequestURI();
        if (!requestPath.startsWith("/api/v1/")) {
            filterChain.doFilter(request, response);
            return;
        }

        // API 키 확인
        String apiKey = request.getParameter("apiKey");
        String clientIp = request.getRemoteAddr();

        // API 키가 없거나 유효하지 않은 경우
        if (apiKey == null || !apiKeyService.isValidApiKey(apiKey, clientIp)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType(MediaType.APPLICATION_JSON_VALUE);

            ApiResponse errorResponse = new ApiResponse(false, "유효하지 않은 API 키 또는 IP 주소입니다.", null);
            response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
            return;
        }

        // 인증 통과, 다음 필터 실행
        filterChain.doFilter(request, response);
    }

}
