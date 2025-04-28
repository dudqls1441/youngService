package com.youngbeen.youngService.Service.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.youngbeen.youngService.DTO.SubwayInfoDTO;
import com.youngbeen.youngService.Mapper.BookmarkMapper;
import com.youngbeen.youngService.Service.SubwayService;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.*;

@Service
public class SubwayServiceImpl implements SubwayService {

    private static final Logger logger = LoggerFactory.getLogger(SubwayServiceImpl.class);

    private final BookmarkMapper bookmarkMapper;

    @Autowired
    public SubwayServiceImpl(BookmarkMapper bookmarkMapper) {
        this.bookmarkMapper = bookmarkMapper;
    }

    @Override
    public List<SubwayInfoDTO> getFilteredSubwayInfo(String subwayNm, String statnId, String updnLine) {
        List<SubwayInfoDTO> result = new ArrayList<>();

        try {
            String baseUrl = "http://swopenAPI.seoul.go.kr/api/subway";
            String apiKey = "4f6f49706164756437384c47775844";
            String dataType = "json";
            String serviceName = "realtimeStationArrival";
            String stationName = "ALL";

            String url = String.format("%s/%s/%s/%s/%s", baseUrl, apiKey, dataType, serviceName, stationName);

            String subwayId = this.getSubwayIdByLineId(subwayNm);
            String SubWayNm = this.getSubwayIdByLineNm(subwayId);

            //상하행선구분
            //(0 : 상행/내선, 1 : 하행/외선)
            String updnCode = updnLine.equals("up") ? "상행" : "하행"; // == 대신 equals 사용

            RestTemplate restTemplate = new RestTemplate();
            String response = restTemplate.getForObject(url, String.class);

            JSONObject json = new JSONObject(response);
            JSONArray items = json.getJSONArray("realtimeArrivalList");

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                if (item.getString("subwayId").equals(subwayId) &&
                        item.getString("updnLine").equals(updnCode) &&
                        (item.getString("statnId").equals(statnId) || item.getString("statnNm").contains(statnId))) {

                    SubwayInfoDTO info = new SubwayInfoDTO();
                    info.setSubwayId(item.getString("subwayId"));
                    info.setStatnNm(item.getString("statnNm"));
                    info.setUpdnLine(item.getString("updnLine"));
                    info.setTrainLineNm(item.getString("trainLineNm"));
                    info.setArvlMsg2(item.getString("arvlMsg2"));
                    info.setArvlMsg3(item.getString("arvlMsg3"));
                    info.setRecptnDt(item.getString("recptnDt"));
                    info.setBarvlDt(item.getString("barvlDt"));
                    info.setBstatnNm(item.getString("bstatnNm"));
                    info.setLstcarAt(item.getString("lstcarAt"));
                    info.setSubwayId(SubWayNm);

                    result.add(info);
                }
            }

        } catch (Exception e) {
            System.out.println("❌ 오류 발생: " + e.getMessage());
        }
        return result;
    }

    public List<SubwayInfoDTO> getSubwayInfoFromPython(String subwayId, String statnId) {
        List<SubwayInfoDTO> result = new ArrayList<>();

        try {
            String url = UriComponentsBuilder
                    .fromHttpUrl("http://192.168.153.129:5001/subwayInfo")
                    .queryParam("subwayId", subwayId)
                    .queryParam("statnId", statnId)
                    .toUriString();

            logger.debug("ybyb 여기까지");
            logger.debug("url " + url);

            RestTemplate restTemplate = new RestTemplate();
            String json = restTemplate.getForObject(url, String.class);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode arrayNode = mapper.readTree(json);

            for (JsonNode node : arrayNode) {
                SubwayInfoDTO info = new SubwayInfoDTO();
                info.setSubwayId(node.get("subwayId").asText());
                info.setStatnNm(node.get("statnNm").asText());
                info.setUpdnLine(node.get("updnLine").asText());
                info.setTrainLineNm(node.get("trainLineNm").asText());
                info.setArvlMsg2(node.get("arvlMsg2").asText());
                info.setArvlMsg3(node.get("arvlMsg3").asText());
                info.setRecptnDt(node.get("recptnDt").asText());
                info.setBarvlDt(node.get("barvlDt").asText());
                info.setBstatnNm(node.get("bstatnNm").asText());
                info.setLstcarAt(node.get("lstcarAt").asText());

                result.add(info);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        logger.debug("result:::" + result);

        return result;
    }

    public Map<String, String> getStationLatLng(String stationName) {
        String apiKey = "4f6f49706164756437384c47775844";
        String url = "http://swopenapi.seoul.go.kr/api/subway/" + apiKey + "/json/stationInfo/0/1000/" + stationName;

        logger.debug("요청 URL: {}", url);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

        logger.debug("응답: {}", response.getBody());

        JSONObject json = new JSONObject(response.getBody());
        JSONArray stations = json.getJSONArray("stationList");

        // 🔐 에러 메시지 검사
        JSONObject error = json.getJSONObject("errorMessage");
        if (!"INFO-000".equals(error.getString("code"))) {
            throw new RuntimeException("API 오류: " + error.getString("message"));
        }

        JSONArray stationList = json.getJSONArray("stationList");
        if (stationList.isEmpty()) {
            throw new RuntimeException("해당 역에 대한 정보가 없습니다.");
        }

        JSONObject station = stations.getJSONObject(0); // 첫 번째 결과

        Map<String, String> result = new HashMap<>();
        result.put("lat", station.getString("subwayYcnts")); // Y좌표
        result.put("lng", station.getString("subwayXcnts")); // X좌표
        result.put("stationName", station.getString("statnNm"));
        return result;
    }

    public static String getSubwayIdByLineId(String lineName) {
        if (lineName == null) return null;

        switch (lineName) {
            case "1호선":
            case "1":
                return "1001";
            case "2호선":
            case "2":
                return "1002";
            case "3호선":
            case "3":
                return "1003";
            case "4호선":
            case "4":
                return "1004";
            case "5호선":
            case "5":
                return "1005";
            case "6호선":
            case "6":
                return "1006";
            case "7호선":
            case "7":
                return "1007";
            case "8호선":
            case "8":
                return "1008";
            case "9호선":
            case "9":
                return "1009";
            case "중앙선":
                return "1061";
            case "경의중앙선":
                return "1063";
            case "공항철도":
                return "1065";
            case "경춘선":
                return "1067";
            case "수의분당선":
                return "1075";
            case "신분당선":
                return "1077";
            case "우이신설선":
                return "1092";
            case "GTX-A":
                return "1032";
            default:
                return null;
        }
    }

    public static String getSubwayIdByLineNm(String lineName) {
        if (lineName == null) return null;

        switch (lineName) {
            case "1001":
                return "1호선";
            case "1002":
                return "2호선";
            case "1003":
                return "3호선";
            case "1004":
                return "4호선";
            case "1005":
                return "5호선";
            case "1006":
                return "6호선";
            case "1007":
                return "7호선";
            case "1008":
                return "8호선";
            case "1009":
                return "9호선";
            case "1061":
                return "중앙선";
            case "1063":
                return "경의중앙선";
            case "1065":
                return "공항철도";
            case "1067":
                return "경춘선";
            case "1075":
                return "수의분당선";
            case "1077":
                return "신분당선";
            case "1092":
                return "우이신설선";
            case "1032":
                return "GTX-A";
            default:
                return null;
        }
    }

    @Override
    public void updateBookmark(Map<String, Object> bookmark) {
        bookmarkMapper.updateBookmark(bookmark);
    }

    @Override
    public boolean checkBookmark(Map<String, Object> bookmark) {
        return bookmarkMapper.checkBookmark(bookmark);
    }

    @Override
    public void deleteBookmark(Map<String, Object> bookmark) {
        bookmarkMapper.deleteBookmark(bookmark);
    }

    @Override
    public List<SubwayInfoDTO> selectBookmark(Map<String, Object> bookmark) {
        List<SubwayInfoDTO> result = new ArrayList<>();

        Map<String,SubwayInfoDTO> info = new LinkedHashMap<>();
        bookmarkMapper.deleteBookmark(bookmark);

        return result;
    }
}