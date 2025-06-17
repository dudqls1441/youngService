package com.youngbeen.youngService.kafka.cunsumer;

import com.youngbeen.youngService.Controller.IndexController;
import com.youngbeen.youngService.DTO.MessageDTO;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

// 간단한 Consumer
@Component
@Slf4j
public class MessageConsumer {
    private final List<MessageDTO> receivedMessages = new ArrayList<>();

    private static final Logger logger = LoggerFactory.getLogger(MessageConsumer.class);

    // 메시지 수신 처리
    @KafkaListener(topics = "test-topic", groupId = "test-group")
    public void handleMessage(MessageDTO message) {
        logger.info("📨 Message received: {} from {} at {}",
                message.getMessage(),
                message.getSender(),
                message.getTimestamp());

        // 받은 메시지 저장
        receivedMessages.add(message);

        // 간단한 처리 로직
        processMessage(message);
    }

    private void processMessage(MessageDTO message) {
        // 메시지 내용에 따른 간단한 처리
        if (message.getMessage().toLowerCase().contains("hello")) {
            logger.info("👋 Hello message detected!");
        } else if (message.getMessage().toLowerCase().contains("test")) {
            logger.info("🧪 Test message detected!");
        }

        // 메시지 카운트 출력
        logger.info("📊 Total messages received: {}", receivedMessages.size());
    }

    // 받은 메시지 목록 조회
    public List<MessageDTO> getReceivedMessages() {
        return new ArrayList<>(receivedMessages);
    }

    // 메시지 개수 조회
    public int getMessageCount() {
        return receivedMessages.size();
    }
}
