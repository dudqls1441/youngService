package com.youngbeen.youngService.Controller;

import com.youngbeen.youngService.DTO.WeatherDTO;
import com.youngbeen.youngService.Service.WeatherService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;


@RestController
public class WeatherController {

    private static final Logger logger = LoggerFactory.getLogger(WeatherController.class);

    @Autowired
    private WeatherService weatherService;

@GetMapping("/api/weather")
@ResponseBody
    public Map<String, Object> getWeatherInfo(@RequestParam(value = "location", required = false) String location) {
        logger.debug("getWeatherInfo Start");
        logger.debug("location::"+location);
        if (location == null || location.isBlank()) {
            location = "인천";
        }

        Map<String, Object> response = new HashMap<>();
        WeatherDTO weatherDTO;
        weatherDTO = weatherService.getWeatherInfo(location);
        response.put("weathers", weatherDTO);
        return response;
    }
}