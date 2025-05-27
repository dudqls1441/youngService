package com.youngbeen.youngService;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

public class ServletInitializer extends SpringBootServletInitializer {

    public ServletInitializer() {
        // 필터 등록 비활성화
        setRegisterErrorPageFilter(false);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(YoungServiceApplication.class)
                .properties(
                        "spring.main.allow-bean-definition-overriding=true",
                        "server.error.whitelabel.enabled=false"
                );
    }
}