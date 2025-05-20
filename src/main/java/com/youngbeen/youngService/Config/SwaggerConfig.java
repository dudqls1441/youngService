package com.youngbeen.youngService.Config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.parameters.Parameter;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springdoc.core.customizers.OperationCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Young Service API")
                        .version("1.0")
                        .description("풋살 팀 밸런싱 및 선수 평가, 주식 정보 제공을 위한 RESTful API 문서")
                        .contact(new Contact()
                                .name("김영빈")
                                .email("dudqls1441@naver.com")
                                .url("https://github.com/dudqls1441/youngService"))
                        .license(new License()
                                .name("MIT License")
                                .url("https://opensource.org/licenses/MIT"))
                )
                .components(new Components()
                        .addSecuritySchemes("apiKey", new SecurityScheme()
                                .type(SecurityScheme.Type.APIKEY)
                                .in(SecurityScheme.In.QUERY)
                                .name("apiKey")
                                .description("API 키 인증")
                        )
                );
    }

    @Bean
    public OperationCustomizer addApiKeyParameter() {
        return (operation, handlerMethod) -> {
            // 모든 API 엔드포인트에 apiKey 파라미터 추가
            Parameter apiKeyParam = new Parameter()
                    .in("query")
                    .name("apiKey")
                    .description("API 키 (필수)")
                    .required(true)
                    .schema(new io.swagger.v3.oas.models.media.StringSchema());

            operation.addParametersItem(apiKeyParam);
            return operation;
        };
    }
}

