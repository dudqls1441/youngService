package com.youngbeen.youngService.Config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        //registry.addRedirectViewController("/", "/member/login"); // 이 설정이 루프의 원인
        //registry.addViewController("/").setViewName("index"); // 이 설정만 유지해야 함
    }
}
