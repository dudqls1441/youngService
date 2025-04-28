package com.youngbeen.youngService.Service.impl;

import com.youngbeen.youngService.DTO.ForecastDTO;
import com.youngbeen.youngService.DTO.WeatherDTO;
import com.youngbeen.youngService.Service.WeatherService;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.net.URISyntaxException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;


@Service
public class WeatherServiceImpl implements WeatherService {

    @Value("${weather.api.key}")
    private String apiKey;

    // 지역별 격자 X, Y 좌표 (기상청 API용)
    private static final Map<String, int[]> LOCATION_GRID = new HashMap<>();

    private static final Logger logger = LoggerFactory.getLogger(WeatherServiceImpl.class);

    static {
        // 주요 도시 격자 좌표 (기상청 API 규격에 맞게 설정)
        // 참고: https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15084084
        LOCATION_GRID.put("서울", new int[]{60, 127});
        LOCATION_GRID.put("부산", new int[]{98, 76});
        LOCATION_GRID.put("인천", new int[]{55, 124});
        LOCATION_GRID.put("대구", new int[]{89, 90});
        LOCATION_GRID.put("대전", new int[]{67, 100});
        LOCATION_GRID.put("광주", new int[]{58, 74});
        LOCATION_GRID.put("울산", new int[]{102, 84});
        LOCATION_GRID.put("제주", new int[]{52, 38});
    }

    @Override
    public WeatherDTO getWeatherInfo(String location) {
        // 기본 위치가 없으면 서울로 설정
        if (location == null || location.isBlank()) {
            location = "서울";
        }

        // 해당 위치의 격자 좌표 가져오기
        int[] grid = LOCATION_GRID.getOrDefault(location, new int[]{60, 127}); // 기본값은 서울
        int nx = grid[0];
        int ny = grid[1];

        // 현재 날짜와 시간 정보
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();

        // API 호출을 위한 기준 시간 설정 (API가 3시간 단위로 업데이트됨)
        int baseHour = (now.getHour() / 3) * 3;
        String baseDate = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String tmpBaseDate = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String baseTime = String.format("%02d00", baseHour);
        logger.debug("baseTime:::"+baseTime);
        logger.debug("now.getHour():::"+now.getHour());
        String tmpBaseTime = "0500";


        // 기상청 단기예보 API URL 구성
        String url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst" +
                "?serviceKey=" + apiKey +  // 이미 인코딩된 키를 그대로 사용
                "&numOfRows=1000" +
                "&pageNo=1" +
                "&dataType=JSON" +
                "&base_date=" + baseDate +
                "&base_time=" + tmpBaseTime +
                "&nx=" + nx +
                "&ny=" + ny;

        RestTemplate restTemplate = new RestTemplate();
        String response;

        try {
            URI uri = new URI(url);
            response = restTemplate.getForObject(uri, String.class);
            logger.debug("url : {} : ", uri);
            // 응답이 XML인지 JSON인지 확인
            if (response.trim().startsWith("<")) {
                // XML 응답이 왔다면 서비스 키 오류가 있는지 확인
                if (response.contains("SERVICE_KEY_IS_NOT_REGISTERED_ERROR")) {
                    logger.error("API 키 등록 오류: {}", response);
                    return getErrorWeatherDTO(location, "API 키 등록 오류");
                }

                // 다른 XML 오류 처리
                logger.error("XML 응답을 받았습니다: {}", response);
                return getErrorWeatherDTO(location, "API 응답 형식 오류 (XML 수신)");
            }
        } catch (URISyntaxException e) {
            logger.error("잘못된 URI 형식: {}", e.getMessage(), e);
            return getErrorWeatherDTO(location, "잘못된 URI 형식");
        } catch (Exception e) {
            logger.error("기상청 API 호출 중 오류 발생: {}", e.getMessage(), e);
            return getErrorWeatherDTO(location, "API 호출 실패");
        }

        // 날씨 정보 추출
        WeatherDTO weatherDTO = new WeatherDTO();

        // API 응답 파싱
        try {
            JSONObject jsonObject = new JSONObject(response);
            JSONObject responseBody = jsonObject.getJSONObject("response").getJSONObject("body");
            JSONObject items = responseBody.getJSONObject("items");
            JSONArray itemArray = items.getJSONArray("item");

            weatherDTO.setCity("대한민국");
            weatherDTO.setDistrict(location);

            // 필요한 데이터 추출
            double temp = 0;
            double maxTemp = -100;
            double minTemp = 100;
            int humidity = 0;
            double windSpeed = 0;
            String skyCondition = "";
            String ptyCondition = "";

            // 예보 데이터를 시간대별로 정리할 맵
            Map<String, ForecastDTO> forecastMap = new LinkedHashMap<>();

            for (int i = 0; i < itemArray.length(); i++) {
                JSONObject item = itemArray.getJSONObject(i);
                String category = item.getString("category");
                String fcstDate = item.getString("fcstDate");
                String fcstTime = item.getString("fcstTime");
                String fcstValue = item.getString("fcstValue");

                // 오늘 날짜의 데이터만 처리
                if (fcstDate.equals(baseDate)) {
                    // 현재 시간대의 데이터 처리
                    if (fcstTime.equals(baseTime) || fcstTime.equals(String.format("%02d00", now.getHour()))) {
                        switch (category) {
                            case "TMP": // 기온
                                temp = Double.parseDouble(fcstValue);
                                break;
                            case "TMX": // 최고기온
                                maxTemp = Double.parseDouble(fcstValue);
                                break;
                            case "TMN": // 최저기온
                                minTemp = Double.parseDouble(fcstValue);
                                break;
                            case "REH": // 습도
                                humidity = Integer.parseInt(fcstValue);
                                break;
                            case "WSD": // 풍속
                                windSpeed = Double.parseDouble(fcstValue);
                                break;
                            case "SKY": // 하늘상태
                                skyCondition = mapSkyCondition(fcstValue);
                                break;
                            case "PTY": // 강수형태
                                ptyCondition = mapPrecipitationType(fcstValue);
                                break;
                        }
                    }

                    // 다음 시간대 예보 데이터 수집
                    // 현재 시간 이후 4개의 시간대를 수집
                    String timeKey = fcstTime;


                    // 시간을 기준으로 데이터 그룹화
                    if (!forecastMap.containsKey(timeKey)) {
                        // 새 시간대면 예보 객체 생성
                        ForecastDTO forecast = new ForecastDTO();
                        String displayTime = formatTime(fcstTime);
                        forecast.setTimeOfDay(displayTime);
                        forecastMap.put(timeKey, forecast);
                    }

                    ForecastDTO forecast = forecastMap.get(timeKey);

                    // 해당 시간대의 데이터 업데이트
                    switch (category) {
                        case "TMP": // 기온
                            forecast.setTemperature(Double.parseDouble(fcstValue));
                            break;
                        case "SKY": // 하늘상태
                            String skyIcon = getSkyIcon(fcstValue);
                            forecast.setIcon(skyIcon);
                            break;
                        case "PTY": // 강수형태
                            if (!fcstValue.equals("0")) { // 비/눈이 있는 경우
                                String ptyIcon = getPrecipitationIcon(fcstValue);
                                forecast.setIcon(ptyIcon); // 강수 아이콘이 우선
                            }
                            break;
                    }
                }
            }

            logger.debug("forecastMap:::"+forecastMap);

            // 최종 날씨 정보 설정
            weatherDTO.setTemperature(temp);
            weatherDTO.setMaxTemp(maxTemp != -100 ? maxTemp : temp);
            weatherDTO.setMinTemp(minTemp != 100 ? minTemp : temp);
            weatherDTO.setHumidity(humidity);
            weatherDTO.setWindSpeed(windSpeed);

            // 날씨 상태 설정 (강수 형태 우선, 없으면 하늘 상태)
            if (!ptyCondition.isEmpty()) {
                weatherDTO.setCondition(ptyCondition);
                weatherDTO.setIcon(getPrecipitationIcon(ptyCondition));
            } else {
                weatherDTO.setCondition(skyCondition);
                weatherDTO.setIcon(getSkyIcon(skyCondition));
            }

            // 예보 정보 정리 (현재 이후 4개 시간대만)
            List<ForecastDTO> forecastList = new ArrayList<>();

            List<String> sortedKeys = new ArrayList<>(forecastMap.keySet());
            Collections.sort(sortedKeys);

            for (int i = 0; i < sortedKeys.size(); i += 4) {
                String key = sortedKeys.get(i);
                ForecastDTO forecast = forecastMap.get(key);

                // 온도 0 초과 필터링
                if (forecast.getTemperature() > 0) {
                    forecastList.add(forecast);
                }
                // 4개까지만
                if (forecastList.size() >= 4) break;
            }
            weatherDTO.setForecast(forecastList);

        } catch (Exception e) {
            logger.error("날씨 응답 파싱 중 오류 발생: {}", e.getMessage(), e);
            return getErrorWeatherDTO(location, "데이터 파싱 실패");
        }
        return weatherDTO;
    }

    @Override
    public List<String> getLocationList() {
        // 설정된 도시 목록 반환
        return new ArrayList<>(LOCATION_GRID.keySet());
    }

    /**
     * 하늘상태 코드를 텍스트로 변환
     */
    private String mapSkyCondition(String code) {
        switch (code) {
            case "1": return "맑음";
            case "3": return "구름많음";
            case "4": return "흐림";
            default: return "알 수 없음";
        }
    }

    /**
     * 강수형태 코드를 텍스트로 변환
     */
    private String mapPrecipitationType(String code) {
        switch (code) {
            case "0": return ""; // 없음
            case "1": return "비";
            case "2": return "비/눈";
            case "3": return "눈";
            case "4": return "소나기";
            default: return "알 수 없음";
        }
    }

    /**
     * 하늘상태 코드를 Font Awesome 아이콘으로 변환
     */
    private String getSkyIcon(String code) {
        switch (code) {
            case "1":
            case "맑음": return "sun";
            case "3":
            case "구름많음": return "cloud-sun";
            case "4":
            case "흐림": return "cloud";
            default: return "cloud";
        }
    }

    /**
     * 강수형태 코드를 Font Awesome 아이콘으로 변환
     */
    private String getPrecipitationIcon(String code) {
        switch (code) {
            case "1":
            case "비": return "cloud-rain";
            case "2":
            case "비/눈": return "cloud-sleet";
            case "3":
            case "눈": return "snowflake";
            case "4":
            case "소나기": return "cloud-showers-heavy";
            default: return "cloud";
        }
    }

    /**
     * 시간 형식 변환 (HHMM -> 오전/오후 H시)
     */
    private String formatTime(String timeString) {
        int hour = Integer.parseInt(timeString.substring(0, 2));
        String amPm = hour < 12 ? "오전" : "오후";
        hour = hour % 12;
        if (hour == 0) hour = 12;
        return amPm + " " + hour + "시";
    }

    private WeatherDTO getErrorWeatherDTO(String location, String message) {
        WeatherDTO dto = new WeatherDTO();
        dto.setCity("대한민국");
        dto.setDistrict(location);
        dto.setCondition("정보 없음");
        dto.setTemperature(0);
        dto.setMaxTemp(0);
        dto.setMinTemp(0);
        dto.setHumidity(0);
        dto.setWindSpeed(0);
        dto.setIcon("exclamation-triangle"); // 오류 아이콘
        logger.warn("날씨 정보 조회 실패: {}", message);
        return dto;
    }
}
