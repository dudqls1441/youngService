package com.youngbeen.youngService.Mapper;

import com.youngbeen.youngService.DTO.SubwayInfoDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface BookmarkMapper {
    void updateBookmark(Map<String, Object> bookmark);
    boolean checkBookmark(Map<String, Object> bookmark);
    void deleteBookmark(Map<String, Object> bookmark);
    List<SubwayInfoDTO> selectBookmark();
}
