package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.TrafficDataDTO;
import com.youngbeen.youngService.Service.TrafficDataService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
public class oraController {

    private static final Logger logger = LoggerFactory.getLogger(oraController.class);

    private final TrafficDataService service;

    public oraController(TrafficDataService service) {
        this.service = service;
    }

    @GetMapping("/traffic")
    public List<TrafficDataDTO> getAllData() {
        List<TrafficDataDTO> tmpData = service.getAllTrafficData();

        logger.debug("tmpData:::"+tmpData);

        return tmpData;
    }


    @GetMapping("/traffic/analyze")
    public List<TrafficDataDTO> getAnalyzedData() {
        String hqName = "서울경기본부";

        String RegionCode = service.getSelectHqCode(hqName);
        List<TrafficDataDTO> tmpData = service.getAnalyzedData(RegionCode);

        List<TrafficDataDTO> filledList = new ArrayList<>();

        for(TrafficDataDTO dto : tmpData){
            TrafficDataDTO newDto = new TrafficDataDTO();

            newDto.setRegionName(dto.getRegionName());
            newDto.setTcsName(dto.getTcsName());
            newDto.setTrafficAmount(dto.getTrafficAmount());
            newDto.setSumTm(dto.getSumTm());
            newDto.setCarType(dto.getCarType());

            filledList.add(newDto);
        }

        logger.debug("filledList:::"+ filledList);


        return filledList;
    }
}
