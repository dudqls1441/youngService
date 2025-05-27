package com.youngbeen.youngService.DTO;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class MemberDetailDTO {
    private String memberId;
    private LocalDate birthDate;
    private String phoneNumber;
    private String gender;
    private String postcode;
    private String address1;
    private String address2;
    private String highSchool;
    private Integer highSchoolGraduationYear;
    private String university;
    private String universityStatus;
    private String major;
    private BigDecimal gpa;
    private Integer universityEntranceYear;
    private Integer universityGraduationYear;
    private List<CertificateDTO> certificates = new ArrayList<>();
}
