package com.youngbeen.youngService.Entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "MEMBER")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Member {
    @Id
    @Column(name = "ID", length = 20) // VARCHAR2(20 BYTE)에 맞게 설정
    private String id; // Long에서 String으로 변경

    @Column(name = "USERNAME", nullable = false, length = 50, unique = true)
    private String username;

    @Column(name = "PASSWORD", nullable = false, length = 100)
    private String password;

    @Column(name = "EMAIL", nullable = false, length = 100, unique = true)
    private String email;

    @Column(name = "EMAIL_VERIFIED")
    @Builder.Default
    private Integer emailVerified = 0; // 기본값은 0(미인증)

    @Column(name = "ROLE", nullable = false, length = 20)
    @Enumerated(EnumType.STRING)
    private Role role;

    @Column(name = "CREATED_DATE")
    private LocalDateTime createdDate;

    @Column(name = "MODIFIED_DATE")
    private LocalDateTime modifiedDate;

    @PrePersist
    public void prePersist() {
        this.createdDate = LocalDateTime.now();
        this.modifiedDate = LocalDateTime.now();
        if (this.role == null) {
            this.role = Role.USER;
        }
    }

    @PreUpdate
    public void preUpdate() {
        this.modifiedDate = LocalDateTime.now();
    }

    public enum Role {
        ADMIN, USER
    }

    @Transient
    public boolean isEmailVerifiedBoolean() {
        return emailVerified != null && emailVerified == 1;
    }

    public void setEmailVerifiedBoolean(boolean verified) {
        this.emailVerified = verified ? 1 : 0;
    }
}
