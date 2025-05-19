package com.youngbeen.youngService.Entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "MEMBER_DETAIL")
@Getter
@Setter
@NoArgsConstructor
public class MemberDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_member_detail")
    @SequenceGenerator(name = "seq_member_detail", sequenceName = "SEQ_MEMBER_DETAIL", allocationSize = 1)
    @Column(name = "ID")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MEMBER_ID", nullable = false)
    private Member member;

    @Column(name = "BIRTH_DATE")
    private LocalDate birthDate;

    @Column(name = "PHONE_NUMBER", length = 20)
    private String phoneNumber;

    @Column(name = "GENDER", length = 1)
    private String gender;

    @Column(name = "PROFILE_IMAGE", length = 255)
    private String profileImage;

    @Column(name = "POSTCODE", length = 10)
    private String postcode;

    @Column(name = "ADDRESS1", length = 255)
    private String address1;

    @Column(name = "ADDRESS2", length = 255)
    private String address2;

    @Column(name = "HIGH_SCHOOL", length = 100)
    private String highSchool;

    @Column(name = "HIGH_SCHOOL_GRADUATION_YEAR")
    private Integer highSchoolGraduationYear;

    @Column(name = "UNIVERSITY", length = 100)
    private String university;

    @Column(name = "UNIVERSITY_STATUS", length = 20)
    private String universityStatus;

    @Column(name = "MAJOR", length = 100)
    private String major;

    @Column(name = "GPA", columnDefinition = "NUMBER(3,2)")
    private Double gpa;

    @Column(name = "UNIVERSITY_ENTRANCE_YEAR")
    private Integer universityEntranceYear;

    @Column(name = "UNIVERSITY_GRADUATION_YEAR")
    private Integer universityGraduationYear;

    @Column(name = "CREATED_DATE")
    private LocalDateTime createdDate;

    @Column(name = "MODIFIED_DATE")
    private LocalDateTime modifiedDate;

    @OneToMany(mappedBy = "memberDetail", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Certificate> certificates = new ArrayList<>();

    // 편의 메소드: 자격증 추가
    public void addCertificate(Certificate certificate) {
        certificates.add(certificate);
        certificate.setMemberDetail(this);
    }

    // 편의 메소드: 자격증 제거
    public void removeCertificate(Certificate certificate) {
        certificates.remove(certificate);
        certificate.setMemberDetail(null);
    }

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
