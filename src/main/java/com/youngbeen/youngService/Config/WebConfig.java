package com.youngbeen.youngService.Config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // 인덱스 페이지로 매핑
        registry.addViewController("/").setViewName("index");
    }

    // 필요한 경우 정적 리소스 처리 설정 추가
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
/*        registry.addResourceHandler("/resources/**")
                .addResourceLocations("classpath:/static/resources/");*/

        // 프로필 이미지 접근 경로 설정
/*        registry.addResourceHandler("/profile/**")
                .addResourceLocations("file:/path/to/profile/images/");*/
    }
}
