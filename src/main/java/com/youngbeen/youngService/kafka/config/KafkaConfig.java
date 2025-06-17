package com.youngbeen.youngService.kafka.config;


import com.youngbeen.youngService.DTO.BulkUpdateTaskDTO;
import com.youngbeen.youngService.DTO.MessageDTO;
import com.youngbeen.youngService.DTO.StockInfoDTO;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.*;
import org.springframework.kafka.listener.DefaultErrorHandler;
import org.springframework.kafka.support.serializer.ErrorHandlingDeserializer;
import org.springframework.kafka.support.serializer.JsonDeserializer;
import org.springframework.kafka.support.serializer.JsonSerializer;
import org.springframework.util.backoff.FixedBackOff;

import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableKafka
public class KafkaConfig {
    // Producer 설정 + Consumer 설정 + 오류 처리


    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    // ========== 공통 Producer 설정 ==========
    private Map<String, Object> getProducerProps() {
        Map<String, Object> configProps = new HashMap<>();
        // Kafka 브로커 주소
        configProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        // 키 직렬화: String → 바이트
        configProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        // 값 직렬화: Java 객체 → JSON → 바이트
        configProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
        // 모든 파티션에서 확인 후 응답 (안전성 최대)
        configProps.put(ProducerConfig.ACKS_CONFIG, "all");
        // 실패 시 3번 재시도
        configProps.put(ProducerConfig.RETRIES_CONFIG, 3);
        return configProps;
    }

    // ========== MessageDTO 설정 ==========
    @Bean
    public ProducerFactory<String, MessageDTO> messageProducerFactory() {
        return new DefaultKafkaProducerFactory<>(getProducerProps());
    }

    //타입별 Producer Bean
    // MessageDTO 전용 Producer
    @Bean("messageKafkaTemplate")  // 🔧 명시적 Bean 이름 지정
    public KafkaTemplate<String, MessageDTO> messageKafkaTemplate() {
        return new KafkaTemplate<>(messageProducerFactory());
    }

    // BulkUpdateTaskDTO 전용 Producer
    @Bean("bulkUpdateKafkaTemplate")  // 🔧 명시적 Bean 이름 지정
    public KafkaTemplate<String, BulkUpdateTaskDTO> bulkUpdateKafkaTemplate() {
        return new KafkaTemplate<>(bulkUpdateProducerFactory());
    }

    @Bean
    public ConsumerFactory<String, MessageDTO> messageConsumerFactory() {
        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "test-group-fixed-v1");  // 🔧 새로운 그룹 ID
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");  // 🔧 최신 메시지부터 시작

        // 🔧 ErrorHandlingDeserializer 사용
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, ErrorHandlingDeserializer.class);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ErrorHandlingDeserializer.class);

        // 실제 Deserializer 설정
        props.put(ErrorHandlingDeserializer.KEY_DESERIALIZER_CLASS, StringDeserializer.class);
        props.put(ErrorHandlingDeserializer.VALUE_DESERIALIZER_CLASS, JsonDeserializer.class);

        // JsonDeserializer 설정
        props.put(JsonDeserializer.TRUSTED_PACKAGES, "*");
        props.put(JsonDeserializer.USE_TYPE_INFO_HEADERS, false);
        props.put(JsonDeserializer.VALUE_DEFAULT_TYPE, MessageDTO.class.getName());

        return new DefaultKafkaConsumerFactory<>(props);
    }

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, MessageDTO> messageKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, MessageDTO> factory =
                new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(messageConsumerFactory());

        // 🔧 강력한 오류 처리 추가
        DefaultErrorHandler errorHandler = new DefaultErrorHandler(
                (consumerRecord, exception) -> {
                    System.err.println("=== MessageDTO 처리 실패 - 건너뛰기 ===");
                    System.err.println("토픽: " + consumerRecord.topic());
                    System.err.println("오프셋: " + consumerRecord.offset());
                    System.err.println("키: " + consumerRecord.key());
                    System.err.println("오류: " + exception.getMessage());
                    System.err.println("=====================================");
                },
                new FixedBackOff(0L, 0L) // 재시도 안함, 바로 건너뛰기
        );

        // 모든 역직렬화 오류는 재시도하지 않음
        errorHandler.addNotRetryableExceptions(
                org.springframework.kafka.support.serializer.DeserializationException.class,
                org.apache.kafka.common.errors.RecordDeserializationException.class,
                IllegalStateException.class,
                com.fasterxml.jackson.core.JsonProcessingException.class
        );

        factory.setCommonErrorHandler(errorHandler);
        return factory;
    }

    // ========== BulkUpdateTaskDTO 설정 ==========
    @Bean
    public ProducerFactory<String, BulkUpdateTaskDTO> bulkUpdateProducerFactory() {
        return new DefaultKafkaProducerFactory<>(getProducerProps());
    }

    @Bean
    public ConsumerFactory<String, BulkUpdateTaskDTO> bulkUpdateConsumerFactory() {
        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        // 컨슈머 그룹 이름 (같은 그룹은 메시지를 나눠서 처리)
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "bulk-update-group-fixed-v1");  // 🔧 새로운 그룹 ID
        // 처음 시작할 때 최신 메시지부터 읽기
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");  // 🔧 최신 메시지부터 시작

        //  ErrorHandlingDeserializer 사용
        // ErrorHandlingDeserializer: 역직렬화 오류 처리
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, ErrorHandlingDeserializer.class);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ErrorHandlingDeserializer.class);

        // 실제 Deserializer 설정
        props.put(ErrorHandlingDeserializer.KEY_DESERIALIZER_CLASS, StringDeserializer.class);
        props.put(ErrorHandlingDeserializer.VALUE_DESERIALIZER_CLASS, JsonDeserializer.class);

        // JsonDeserializer 설정
        // 모든 패키지의 클래스 역직렬화 허용
        props.put(JsonDeserializer.TRUSTED_PACKAGES, "*");
        // 헤더의 타입 정보 무시
        props.put(JsonDeserializer.USE_TYPE_INFO_HEADERS, false);

        // 기본적으로 BulkUpdateTaskDTO로 역직렬화
        props.put(JsonDeserializer.VALUE_DEFAULT_TYPE, BulkUpdateTaskDTO.class.getName());

        return new DefaultKafkaConsumerFactory<>(props);
    }

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, BulkUpdateTaskDTO> bulkUpdateKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, BulkUpdateTaskDTO> factory =
                new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(bulkUpdateConsumerFactory());

        // 강력한 오류 처리 추가
        DefaultErrorHandler errorHandler = new DefaultErrorHandler(
                (consumerRecord, exception) -> {
                    // 오류 발생 시 로깅 후 건너뛰기
                    System.err.println("=== BulkUpdateTaskDTO 처리 실패 - 건너뛰기 ===");
                    System.err.println("토픽: " + consumerRecord.topic());
                    System.err.println("파티션: " + consumerRecord.partition());
                    System.err.println("오프셋: " + consumerRecord.offset());
                    System.err.println("키: " + consumerRecord.key());
                    System.err.println("오류: " + exception.getMessage());
                    System.err.println("===========================================");
                },
                new FixedBackOff(0L, 0L) // 재시도 안함, 바로 건너뛰기
        );

        // 모든 역직렬화 오류는 재시도하지 않음
        errorHandler.addNotRetryableExceptions(
                org.springframework.kafka.support.serializer.DeserializationException.class,
                org.apache.kafka.common.errors.RecordDeserializationException.class,
                IllegalStateException.class,
                com.fasterxml.jackson.core.JsonProcessingException.class,
                com.fasterxml.jackson.databind.JsonMappingException.class
        );

        factory.setCommonErrorHandler(errorHandler);
        return factory;
    }

}
