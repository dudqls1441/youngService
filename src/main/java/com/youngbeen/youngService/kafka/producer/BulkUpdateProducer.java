package com.youngbeen.youngService.kafka.producer;


import com.youngbeen.youngService.DTO.BulkUpdateTaskDTO;
import com.youngbeen.youngService.Mapper.StockInfoMapper;
import com.youngbeen.youngService.Service.impl.StockServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class BulkUpdateProducer {
    private static final Logger logger = LoggerFactory.getLogger(BulkUpdateProducer.class);
    private static final String TOPIC = "bulk-update-topic";

    // 🔧 @Qualifier 추가하여 올바른 Bean 주입
    @Autowired
    @Qualifier("bulkUpdateKafkaTemplate")
    private KafkaTemplate<String, BulkUpdateTaskDTO> bulkUpdateKafkaTemplate;

    @Autowired
    private StockInfoMapper stockInfoMapper;

    public String startBulkUpdate(String requestUser) {
        log.info("🚀 Starting bulk update task for user: {}", requestUser);

        try {
            long totalCount = stockInfoMapper.getTotalCount();

            logger.debug("★ totalCount :: {}", totalCount);
            BulkUpdateTaskDTO task = BulkUpdateTaskDTO.createRemarksUpdate(requestUser);
            task.setTotalCount(totalCount);

            bulkUpdateKafkaTemplate.send(TOPIC, task.getTaskId(), task);

            log.info("Bulk update task sent: {} (Total records: {})", task.getTaskId(), totalCount);
            return task.getTaskId();

        } catch (Exception e) {
            log.error("Failed to start bulk update task", e);
            throw new RuntimeException("대량 업데이트 작업 시작에 실패했습니다: " + e.getMessage());
        }
    }

    // REMARKS 초기화 (NULL로 리셋)
    public String startBulkReset(String requestUser) {
        log.info("Starting bulk reset task for user: {}", requestUser);

        try {
            long totalCount = stockInfoMapper.getTotalCount();

            logger.debug("Reset totalCount :: {}", totalCount);
            BulkUpdateTaskDTO task = BulkUpdateTaskDTO.createRemarksReset(requestUser);
            task.setTotalCount(totalCount);

            bulkUpdateKafkaTemplate.send(TOPIC, task.getTaskId(), task);

            log.info("Bulk reset task sent: {} (Total records: {})", task.getTaskId(), totalCount);
            return task.getTaskId();

        } catch (Exception e) {
            log.error("Failed to start bulk reset task", e);
            throw new RuntimeException("대량 초기화 작업 시작에 실패했습니다: " + e.getMessage());
        }
    }


    //자동 리셋 (완료 상태일 때 자동 호출용)
    public String autoResetAfterCompletion(String requestUser) {
        log.info("🔄 Auto reset triggered after completion for user: {}", requestUser);
        return startBulkReset(requestUser);
    }
}
