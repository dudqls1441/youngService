package com.youngbeen.youngService.kafka.cunsumer;

import com.youngbeen.youngService.DTO.BulkUpdateTaskDTO;
import com.youngbeen.youngService.Mapper.StockInfoMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import java.util.List;

// Consumer - "어떻게 할지" 실제 구현
@Component
@Slf4j
class BulkUpdateConsumer {
    @Autowired
    private StockInfoMapper stockInfoMapper;

    @KafkaListener(topics = "bulk-update-topic",
            groupId = "bulk-update-group-fixed-v1",
            containerFactory = "bulkUpdateKafkaListenerContainerFactory")
    public void processBulkUpdate(BulkUpdateTaskDTO task) {
        String taskId = task.getTaskId();
        String taskType = task.getTaskType();

        log.info("작업 수신: {} - {}", taskId, taskType);
        log.info("Processing bulk update task: {}", task);

        try {
            // 🔧 상수를 사용하여 타입 비교
            if (BulkUpdateTaskDTO.TASK_TYPE_UPDATE_REMARKS.equals(taskType)) {
                // 기존 로직: REMARKS 업데이트
                processRemarksUpdate(task);

            } else if (BulkUpdateTaskDTO.TASK_TYPE_RESET_REMARKS.equals(taskType)) {
                // 새로운 로직: REMARKS 초기화
                processRemarksReset(task);

            } else {
                log.warn("알 수 없는 작업 타입: {}", taskType);
                throw new IllegalArgumentException("Unknown task type: " + taskType);
            }

        } catch (Exception e) {
            log.error("Bulk update task failed: {}", taskId, e);
        }
    }

    // 비고 업데이트 처리 (방법 1: 한 번에 처리)
    private void processRemarksUpdate(BulkUpdateTaskDTO task) {
        String taskId = task.getTaskId();

        log.info("Starting remarks update - Total records: {}", task.getTotalCount());
        log.info("대량 업데이트 시작: 비고 컬럼에 BASDT 값을 입력합니다.");

        try {
            // 방법 1: 한 번에 모든 데이터 업데이트 (가장 빠름)
            long startTime = System.currentTimeMillis();
            int updatedRows = stockInfoMapper.updateAllRemarksWithBasDt();
            long endTime = System.currentTimeMillis();

            log.info("Bulk update completed: {} rows updated in {} ms",
                    updatedRows, (endTime - startTime));

        } catch (Exception e) {
            log.error("Failed to update remarks in bulk", e);

            // 실패 시 배치 방식으로 재시도
            processBatchUpdate(task);
        }
    }

    // 배치 방식 업데이트 (방법 2: 안전한 방식)
    private void processBatchUpdate(BulkUpdateTaskDTO task) {
        String taskId = task.getTaskId();
        int batchSize = task.getBatchSize();

        log.info("Starting batch update with batch size: {}", batchSize);
        log.info("⚠배치 방식으로 안전하게 처리합니다.");

        long totalProcessed = 0;
        long totalSuccess = 0;
        long totalFailed = 0;

        // BASDT별로 처리
        long offset = 0;
        List<String> basDtBatch;

        do {
            // BASDT 목록을 배치로 조회
            basDtBatch = stockInfoMapper.getBasDtBatch(offset, batchSize);

            for (String basDt : basDtBatch) {
                try {
                    // 해당 BASDT의 모든 레코드를 비고에 BASDT 값으로 업데이트
                    int updated = stockInfoMapper.updateRemarksByBasDt(basDt, basDt);

                    totalProcessed += updated;
                    totalSuccess += updated;

                    log.debug("Updated {} records for BASDT: {}", updated, basDt);

                } catch (Exception e) {
                    long failedCount = stockInfoMapper.getCountByBasDt(basDt);
                    totalProcessed += failedCount;
                    totalFailed += failedCount;

                    log.error("Failed to update BASDT: {}", basDt, e);
                }
            }

            // 중간 로그 (1만건마다)
            if (totalProcessed % 10000 == 0 && totalProcessed > 0) {
                log.info("진행상황: {}개 레코드 처리 완료", totalProcessed);
            }

            offset += batchSize;

            // 서버 부하 방지를 위한 잠시 대기
            try {
                Thread.sleep(50);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }

        } while (!basDtBatch.isEmpty());

        log.info("✅ Batch update completed: {} processed, {} success, {} failed",
                totalProcessed, totalSuccess, totalFailed);
    }

    // 초기화
    private void processRemarksReset(BulkUpdateTaskDTO task) {
        String taskId = task.getTaskId();

        log.info("Starting remarks reset - Total records: {}", task.getTotalCount());
        log.info("대량 초기화 시작: 비고 컬럼을 NULL로 초기화합니다.");

        try {
            // 방법 1: 한 번에 모든 데이터 초기화
            long startTime = System.currentTimeMillis();
            int resetRows = stockInfoMapper.resetAllRemarksToNull();
            long endTime = System.currentTimeMillis();

            log.info("Bulk reset completed: {} rows reset to NULL in {} ms",
                    resetRows, (endTime - startTime));

        } catch (Exception e) {
            log.error("Failed to reset remarks in bulk", e);

            // 실패 시 배치 방식으로 재시도
            processBatchReset(task);
        }
    }

    // 배치 방식 초기화
    private void processBatchReset(BulkUpdateTaskDTO task) {
        String taskId = task.getTaskId();
        int batchSize = task.getBatchSize();

        log.info("Starting batch reset with batch size: {}", batchSize);
        log.info("배치 방식으로 안전하게 초기화합니다.");

        long totalProcessed = 0;
        long totalSuccess = 0;
        long totalFailed = 0;

        // 배치 단위로 처리
        long offset = 0;

        do {
            try {
                // 배치 단위로 REMARKS를 NULL로 업데이트
                int resetCount = stockInfoMapper.resetRemarksBatch(offset, batchSize);

                if (resetCount > 0) {
                    totalProcessed += resetCount;
                    totalSuccess += resetCount;

                    log.debug("Reset {} records at offset: {}", resetCount, offset);

                    // 중간 로그 (1만건마다)
                    if (totalProcessed % 10000 == 0) {
                        log.info("🧹 초기화 진행상황: {}개 레코드 처리 완료", totalProcessed);
                    }

                    offset += batchSize;

                    // 서버 부하 방지를 위한 잠시 대기
                    Thread.sleep(50);
                } else {
                    // 더 이상 처리할 데이터가 없음
                    break;
                }

            } catch (Exception e) {
                totalFailed += batchSize;
                log.error("Failed to reset batch at offset: {}", offset, e);

                offset += batchSize; // 다음 배치로 계속 진행
            }

        } while (true);

        log.info("Batch reset completed: {} processed, {} success, {} failed",
                totalProcessed, totalSuccess, totalFailed);
    }
}
