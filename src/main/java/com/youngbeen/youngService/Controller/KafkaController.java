package com.youngbeen.youngService.Controller;


import com.youngbeen.youngService.DTO.MessageDTO;
import com.youngbeen.youngService.Mapper.StockInfoMapper;
import com.youngbeen.youngService.kafka.cunsumer.MessageConsumer;
import com.youngbeen.youngService.kafka.producer.BulkUpdateProducer;
import com.youngbeen.youngService.kafka.producer.MessageProducer;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;


// 테스트용 REST Controller
@RestController
@RequestMapping("/api/kafka-test")
@Slf4j
public class KafkaController {

    private static final Logger logger = LoggerFactory.getLogger(KafkaController.class);

    @Autowired
    private MessageProducer messageProducer;

    @Autowired
    private MessageConsumer messageConsumer;

    @Autowired
    private BulkUpdateProducer bulkUpdateProducer;

    @Autowired
    private StockInfoMapper stockInfoMapper;


    // 단일 메시지 전송 테스트
    @PostMapping("/send")
    public ResponseEntity<String> sendMessage(
            @RequestParam String message,
            @RequestParam(defaultValue = "WebUser") String sender) {

        messageProducer.sendMessage(message, sender);

        return ResponseEntity.ok("Message sent: " + message);
    }

    // 여러 메시지 전송 테스트
    @PostMapping("/send-multiple")
    public ResponseEntity<String> sendMultipleMessages(@RequestBody List<String> messages) {
        messageProducer.sendMultipleMessages(messages, "WebUser");

        return ResponseEntity.ok("Sent " + messages.size() + " messages");
    }

    //  자동 테스트 메시지 전송
    @PostMapping("/auto-test")
    public ResponseEntity<String> runAutoTest() {
        // 비동기로 실행 (즉시 응답)
        CompletableFuture.runAsync(() -> {
            messageProducer.sendTestMessages();
        });

        return ResponseEntity.ok("Auto test started! Check logs for results.");
    }

    // 받은 메시지 조회
    @GetMapping("/received")
    public ResponseEntity<List<MessageDTO>> getReceivedMessages() {
        List<MessageDTO> messages = messageConsumer.getReceivedMessages();
        return ResponseEntity.ok(messages);
    }

    // 메시지 개수 조회
    @GetMapping("/count")
    public ResponseEntity<Map<String, Object>> getMessageCount() {
        int count = messageConsumer.getMessageCount();

        Map<String, Object> response = Map.of(
                "messageCount", count,
                "timestamp", LocalDateTime.now()
        );

        return ResponseEntity.ok(response);
    }

    // Kafka 연결 상태 확인
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> checkKafkaHealth() {
        Map<String, Object> health = Map.of(
                "status", "UP",
                "kafka", "Connected",
                "timestamp", LocalDateTime.now()
        );

        return ResponseEntity.ok(health);
    }



    // 대량 업데이트 시작 버튼
    @PostMapping("/start-remarks-update")
    public ResponseEntity<Map<String, Object>> startRemarksUpdate(
            @RequestParam(defaultValue = "admin") String requestUser) {

        try {
            long totalCount = stockInfoMapper.getTotalCount();
            long updatedCount = stockInfoMapper.getUpdatedCount();

            logger.debug("ybyb totalCount :: {} , updatedCount ::{} ", totalCount, updatedCount);

            // 🔥 새로운 조건: 모든 데이터가 업데이트되었으면 자동 리셋
            if (updatedCount >= totalCount) {
                logger.info("All data updated! Starting auto reset...");
                String resetTaskId = bulkUpdateProducer.autoResetAfterCompletion(requestUser);

                return ResponseEntity.ok(Map.of(
                        "success", true,
                        "taskId", resetTaskId,
                        "message", "모든 데이터가 업데이트 완료되어 자동으로 초기화를 시작합니다.",
                        "action", "AUTO_RESET",
                        "totalCount", totalCount,
                        "previousUpdatedCount", updatedCount
                ));
            }

            // 기존 로직: 일반적인 업데이트 시작
            String taskId = bulkUpdateProducer.startBulkUpdate(requestUser);

            Map<String, Object> response = Map.of(
                    "success", true,
                    "taskId", taskId,
                    "message", "대량 업데이트가 시작되었습니다.",
                    "action", "UPDATE",
                    "totalCount", totalCount,
                    "updatedCount", updatedCount,
                    "remainingCount", totalCount - updatedCount
            );

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Failed to start bulk update", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "error", e.getMessage(),
                    "message", "대량 업데이트 시작에 실패했습니다."
            ));
        }
    }

    // 초기화 API
    @PostMapping("/reset-remarks")
    public ResponseEntity<Map<String, Object>> resetRemarks(
            @RequestParam(defaultValue = "admin") String requestUser) {

        try {
            long totalCount = stockInfoMapper.getTotalCount();

            String resetTaskId = bulkUpdateProducer.startBulkReset(requestUser);

            Map<String, Object> response = Map.of(
                    "success", true,
                    "taskId", resetTaskId,
                    "message", "REMARKS 초기화 작업이 시작되었습니다.",
                    "action", "MANUAL_RESET",
                    "totalCount", totalCount
            );

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("Failed to start bulk reset", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "error", e.getMessage(),
                    "message", "대량 초기화 작업 시작에 실패했습니다."
            ));
        }
    }

    // 현재 상태 조회
    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getUpdateStatus() {
        try {
            long totalCount = stockInfoMapper.getTotalCount();
            long updatedCount = stockInfoMapper.getUpdatedCount();

            Map<String, Object> status = Map.of(
                    "totalCount", totalCount,
                    "updatedCount", updatedCount,
                    "remainingCount", totalCount - updatedCount,
                    "progressPercent", totalCount > 0 ? (updatedCount * 100.0 / totalCount) : 0.0,
                    "isCompleted", updatedCount >= totalCount
            );

            return ResponseEntity.ok(status);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "error", e.getMessage()
            ));
        }
    }




}
