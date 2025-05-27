package com.youngbeen.youngService.Service;

import com.youngbeen.youngService.DTO.SubwayInfoDTO;

import java.util.List;
import java.util.Map;

public interface SubwayService {
    void updateBookmark(Map<String, Object> bookmark);
    boolean checkBookmark(Map<String, Object> bookmark);
    void deleteBookmark(Map<String, Object> bookmark);
    List<SubwayInfoDTO> selectBookmark(Map<String, Object> bookmark);
    List<SubwayInfoDTO> getFilteredSubwayInfo(String subwayId, String statnId, String updnLine);
}
