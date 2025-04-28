package com.youngbeen.youngService.Mapper;

import com.youngbeen.youngService.DTO.TrafficDataDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface TrafficDataMapper {
    List<TrafficDataDTO> getAllTrafficData();

    String getSelectHqCode(String hqName);

    List<TrafficDataDTO> getAnalyzedData(String RegionCode);
}
