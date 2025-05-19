package com.youngbeen.youngService.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "CERTIFICATE")
@Getter
@Setter
@NoArgsConstructor
public class Certificate {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_certificate")
    @SequenceGenerator(name = "seq_certificate", sequenceName = "SEQ_CERTIFICATE", allocationSize = 1)
    @Column(name = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MEMBER_DETAIL_ID", nullable = false)
    private MemberDetail memberDetail;

    @Column(name = "NAME", nullable = false, length = 100)
    private String name;

    @Column(name = "ISSUER", length = 100)
    private String issuer;

    @Column(name = "ACQUISITION_DATE")
    private LocalDate acquisitionDate;

    @Column(name = "EXPIRATION_DATE")
    private LocalDate expirationDate;

    @Column(name = "CREATED_DATE")
    private LocalDateTime createdDate;

    @Column(name = "MODIFIED_DATE")
    private LocalDateTime modifiedDate;

    @PrePersist
    public void prePersist() {
        this.createdDate = LocalDateTime.now();
        this.modifiedDate = this.createdDate;
    }

    @PreUpdate
    public void preUpdate() {
        this.modifiedDate = LocalDateTime.now();
    }
}
