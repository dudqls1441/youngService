package com.youngbeen.youngService.kafka.producer;


import com.youngbeen.youngService.DTO.MessageDTO;
import com.youngbeen.youngService.kafka.cunsumer.MessageConsumer;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

// 간단한 Producer
@Component
@Slf4j
public class MessageProducer {

    private static final String TOPIC = "test-topic";

    private static final Logger logger = LoggerFactory.getLogger(MessageConsumer.class);

    // 🔧 명시적으로 messageKafkaTemplate Bean 주입
    @Autowired
    @Qualifier("messageKafkaTemplate")
    private KafkaTemplate<String, MessageDTO> messageKafkaTemplate;

    // 간단한 메시지 전송
    public void sendMessage(String message, String sender) {
        MessageDTO messageDto = MessageDTO.create(message, sender);

        try {
            messageKafkaTemplate.send(TOPIC, messageDto.getId(), messageDto);
            logger.info("✅ Message sent: {} from {}", message, sender);
        } catch (Exception e) {
            logger.error("❌ Failed to send message: {}", message, e);
        }
    }

    // 여러 메시지 한번에 전송
    public void sendMultipleMessages(List<String> messages, String sender) {
        messages.forEach(message -> sendMessage(message, sender));
    }

    // 자동 메시지 생성 (테스트용)
    public void sendTestMessages() {
        List<String> testMessages = Arrays.asList(
                "Hello Kafka!",
                "This is a test message",
                "Kafka is working!",
                "Spring Boot + Kafka",
                "Test completed!"
        );

        testMessages.forEach(message -> {
            sendMessage(message, "TestSender");

            // 1초 간격으로 전송
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });
    }
}
