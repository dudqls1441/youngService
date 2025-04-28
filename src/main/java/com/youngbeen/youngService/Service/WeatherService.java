package com.youngbeen.youngService.Service;

import com.youngbeen.youngService.DTO.WeatherDTO;

import java.util.List;

public interface WeatherService {
    WeatherDTO getWeatherInfo(String location);
    List<String> getLocationList();
}
