package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.Entity.ApiKey;
import com.youngbeen.youngService.Service.ApiKeyService;
import com.youngbeen.youngService.Service.impl.ApiServcieImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/*
*관리자용 API키 관리 컨드롤러
*/
@Controller
@RequestMapping("/admin/api-keys")
public class ApiKeyManagementController {

    private static final Logger logger = LoggerFactory.getLogger(ApiKeyManagementController.class);

    private final ApiKeyService apiKeyService;

    public ApiKeyManagementController(ApiKeyService apiKeyService) {
        this.apiKeyService = apiKeyService;
    }

    /**
     * API 키 관리 페이지
     */
    @GetMapping
    public String apiKeysPage(Model model) {
        List<ApiKey> apiKeys = apiKeyService.getAllActiveApiKeys();
        model.addAttribute("apiKeys", apiKeys);
        return "admin/api-keys";
    }

    /**
     * 새 API 키 생성
     */
    @PostMapping
    public String createApiKey(
            @RequestParam String clientName,
            @RequestParam String description,
            Model model) {

        ApiKey apiKey = apiKeyService.generateApiKey(clientName, description);
        model.addAttribute("newApiKey", apiKey);

        List<ApiKey> apiKeys = apiKeyService.getAllActiveApiKeys();
        model.addAttribute("apiKeys", apiKeys);

        return "admin/api-keys";
    }

    /**
     * API 키 비활성화
     */
    @PostMapping("/{keyValue}/deactivate")
    public String deactivateApiKey(@PathVariable String keyValue) {
        apiKeyService.deactivateApiKey(keyValue);
        return "redirect:/admin/api-keys";
    }

    /**
     * 허용 IP 주소 업데이트
     */
    @PostMapping("/{keyValue}/ips")
    public String updateAllowedIps(
            @PathVariable String keyValue,
            @RequestParam String allowedIps) {

        apiKeyService.updateAllowedIps(keyValue, allowedIps);
        return "redirect:/admin/api-keys";
    }
}
