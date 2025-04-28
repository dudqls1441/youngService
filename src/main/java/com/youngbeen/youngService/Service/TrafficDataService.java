package com.youngbeen.youngService.Service;

import com.youngbeen.youngService.DTO.TrafficDataDTO;
import com.youngbeen.youngService.Mapper.TrafficDataMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TrafficDataService {

    private final TrafficDataMapper mapper;

    public TrafficDataService(TrafficDataMapper mapper) {
        this.mapper = mapper;
    }

    public List<TrafficDataDTO> getAllTrafficData() {
        return mapper.getAllTrafficData();
    }

    public String getSelectHqCode(@Param("hqName") String hqName) {
        return mapper.getSelectHqCode(hqName).toString();
    }


    public List<TrafficDataDTO> getAnalyzedData(@Param("RegionCode") String RegionCode) {
        return mapper.getAnalyzedData(RegionCode);
    }
}
