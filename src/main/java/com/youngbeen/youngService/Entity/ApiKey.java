package com.youngbeen.youngService.Entity;

import com.youngbeen.youngService.Config.BooleanToNumberConverter;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "API_KEYS")
@Getter
@Setter
public class ApiKey {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Long id;

    @Column(name = "KEY_VALUE", nullable = false, unique = true, length = 64)
    private String keyValue;

    @Column(name = "CLIENT_NAME", nullable = false)
    private String clientName;

    @Column(name = "DESCRIPTION", nullable = false)
    private String description;

    @Column(name = "ACTIVE", nullable = false)
    private Integer active = 1;  // boolean 대신 Integer 사용

    @Column(name = "CREATED_AT", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "LAST_USED_AT")
    private LocalDateTime lastUsedAt;

    @Column(name = "ALLOWED_IPS")
    private String allowedIps;

    // 필요한 메서드 추가
    public boolean isActive() {
        return active != null && active == 1;
    }

    public void setActive(boolean active) {
        this.active = active ? 1 : 0;
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
