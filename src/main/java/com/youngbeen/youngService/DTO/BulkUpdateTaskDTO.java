package com.youngbeen.youngService.DTO;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BulkUpdateTaskDTO {
    //대량 업데이트 작업

    // ========== 상수 정의 ==========
    public static final String TASK_TYPE_UPDATE_REMARKS = "UPDATE_REMARKS";
    public static final String TASK_TYPE_RESET_REMARKS = "RESET_REMARKS";

    private String taskId;              // 작업 ID
    private String taskType;            // "UPDATE_REMARKS" 등
    private String updateValue;         // 업데이트할 값 패턴
    private Integer batchSize;          // 배치 크기 (기본 1000)
    private LocalDateTime requestTime;  // 요청 시간
    private String requestUser;         // 요청 사용자

    // 진행 상황 추적
    private Long totalCount;            // 전체 레코드 수
    private Long processedCount;        // 처리된 레코드 수
    private Long successCount;          // 성공한 레코드 수
    private Long failedCount;           // 실패한 레코드 수

    // 할 일의 "설명서"를 만드는 것
    public static BulkUpdateTaskDTO createRemarksUpdate(String requestUser) {
        return BulkUpdateTaskDTO.builder()
                .taskId("BULK_UPDATE_" + System.currentTimeMillis())
                .taskType(TASK_TYPE_UPDATE_REMARKS)
                .updateValue("BASDT_VALUE")  // BASDT 값으로 업데이트
                .batchSize(1000)
                .requestTime(LocalDateTime.now())
                .requestUser(requestUser)
                .totalCount(0L)
                .processedCount(0L)
                .successCount(0L)
                .failedCount(0L)
                .build();
    }


    // REMARKS 초기화 (NULL로 리셋)
    public static BulkUpdateTaskDTO createRemarksReset(String requestUser) {
        return BulkUpdateTaskDTO.builder()
                .taskId("BULK_RESET_" + System.currentTimeMillis())
                .taskType(TASK_TYPE_RESET_REMARKS)
                .updateValue("NULL")  // NULL로 초기화
                .batchSize(1000)
                .requestTime(LocalDateTime.now())
                .requestUser(requestUser)
                .totalCount(0L)
                .processedCount(0L)
                .successCount(0L)
                .failedCount(0L)
                .build();
    }

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public String getUpdateValue() {
        return updateValue;
    }

    public void setUpdateValue(String updateValue) {
        this.updateValue = updateValue;
    }

    public Integer getBatchSize() {
        return batchSize;
    }

    public void setBatchSize(Integer batchSize) {
        this.batchSize = batchSize;
    }

    public LocalDateTime getRequestTime() {
        return requestTime;
    }

    public void setRequestTime(LocalDateTime requestTime) {
        this.requestTime = requestTime;
    }

    public String getRequestUser() {
        return requestUser;
    }

    public void setRequestUser(String requestUser) {
        this.requestUser = requestUser;
    }

    public Long getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(Long totalCount) {
        this.totalCount = totalCount;
    }

    public Long getProcessedCount() {
        return processedCount;
    }

    public void setProcessedCount(Long processedCount) {
        this.processedCount = processedCount;
    }

    public Long getSuccessCount() {
        return successCount;
    }

    public void setSuccessCount(Long successCount) {
        this.successCount = successCount;
    }

    public Long getFailedCount() {
        return failedCount;
    }

    public void setFailedCount(Long failedCount) {
        this.failedCount = failedCount;
    }

}
