package com.youngbeen.youngService.Service;

import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class ExcelService {

    public List<Map<String, Object>> parseExcelFile(MultipartFile file) throws IOException {
        List<Map<String, Object>> dataList = new ArrayList<>();

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {

            // 첫 번째 시트 읽기
            Sheet sheet = workbook.getSheetAt(0);

            // 헤더 행 읽기 (첫 번째 행을 헤더로 가정)
            Row headerRow = sheet.getRow(0);
            if (headerRow == null) {
                throw new IllegalArgumentException("헤더 행이 없습니다.");
            }

            List<String> headers = new ArrayList<>();
            for (Cell cell : headerRow) {
                headers.add(getCellValueAsString(cell));
            }

            // 데이터 행들 읽기 (두 번째 행부터)
            for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
                Row row = sheet.getRow(rowIndex);
                if (row == null) continue;

                Map<String, Object> rowData = new HashMap<>();
                boolean hasData = false;

                for (int cellIndex = 0; cellIndex < headers.size(); cellIndex++) {
                    Cell cell = row.getCell(cellIndex);
                    String cellValue = getCellValueAsString(cell);

                    if (cellValue != null && !cellValue.trim().isEmpty()) {
                        hasData = true;
                    }

                    rowData.put(headers.get(cellIndex), cellValue);
                }

                // 빈 행이 아닌 경우에만 추가
                if (hasData) {
                    dataList.add(rowData);
                }
            }
        }

        return dataList;
    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) {
            return "";
        }

        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    // 날짜 형식인 경우
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    return sdf.format(cell.getDateCellValue());
                } else {
                    // 숫자인 경우 (소수점 제거)
                    double numericValue = cell.getNumericCellValue();
                    if (numericValue == Math.floor(numericValue)) {
                        return String.valueOf((long) numericValue);
                    } else {
                        return String.valueOf(numericValue);
                    }
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                try {
                    return String.valueOf(cell.getNumericCellValue());
                } catch (Exception e) {
                    return cell.getStringCellValue();
                }
            default:
                return "";
        }
    }
}
