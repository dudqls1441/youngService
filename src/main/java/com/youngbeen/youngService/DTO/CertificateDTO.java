package com.youngbeen.youngService.DTO;


import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class CertificateDTO {
    private String name;
    private String issuer;
    private LocalDate acquisitionDate;
    private LocalDate expirationDate;
}
