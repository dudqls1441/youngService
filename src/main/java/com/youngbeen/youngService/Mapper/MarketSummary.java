package com.youngbeen.youngService.Mapper;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MarketSummary {

    private double kospiIndex;
    private double kospiChange;
    private double kosdaqIndex;
    private double kosdaqChange;
    private LocalDateTime updateTime;
}