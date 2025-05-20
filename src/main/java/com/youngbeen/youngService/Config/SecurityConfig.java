package com.youngbeen.youngService.Config;

import com.youngbeen.youngService.Api.ApiKeyAuthFilter;
import com.youngbeen.youngService.Entity.Member;
import com.youngbeen.youngService.Repository.MemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // 생성자 주입이나 @Autowired
    @Autowired
    private MemberRepository memberRepository;

    private final ApiKeyAuthFilter apiKeyAuthFilter;

    // 생성자 주입
    public SecurityConfig(ApiKeyAuthFilter apiKeyAuthFilter) {
        this.apiKeyAuthFilter = apiKeyAuthFilter;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    @Order(1)  // Swagger UI 접근을 허용하는 필터 체인을 가장 먼저 적용
    public SecurityFilterChain swaggerSecurityFilterChain(HttpSecurity http) throws Exception {
        http
                .securityMatcher("/swagger-ui/**", "/swagger-ui.html", "/v3/api-docs/**", "/webjars/**")
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll()
                );

        return http.build();
    }

    @Bean
    @Order(2)  // API 경로에 대한 필터 체인을 먼저 적용
    public SecurityFilterChain apiSecurityFilterChain(HttpSecurity http) throws Exception {
        http
                .securityMatcher("/api/**")  // API 경로에만 적용
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll()  // API 키 필터에서 인증 처리
                )
                .addFilterBefore(apiKeyAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    @Order(3)  // 웹 애플리케이션 경로에 대한 필터 체인
    public SecurityFilterChain webSecurityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())  // 기존 설정 유지
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/**").permitAll()  // 기존 설정 유지
                )
                .formLogin(login -> login.disable())  // 기존 설정 유지
                .httpBasic(basic -> basic.disable())  // 기존 설정 유지
                .logout(logout -> logout.disable());  // 기존 설정 유지

        return http.build();
    }

    @Bean
    public UserDetailsService userDetailsService() {
        return username -> {
            Member member = memberRepository.findByUsername(username)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));

            return User.builder()
                    .username(member.getUsername())
                    .password(member.getPassword())
                    .roles(member.getRole().name())
                    .build();
        };
    }

}
