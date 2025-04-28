package com.youngbeen.youngService.Mapper;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "financial_data")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FinancialData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "stock_code")
    private String stockCode;

    @Column(name = "period")
    private String period;  // 예: "2023년", "2022년", etc.

    @Column(name = "revenue")
    private String revenue;

    @Column(name = "operating_profit")
    private String operatingProfit;

    @Column(name = "net_income")
    private String netIncome;

    @Column(name = "eps")
    private String eps;

    @Column(name = "per")
    private String per;

    @Column(name = "roe")
    private String roe;
}
