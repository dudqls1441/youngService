package com.youngbeen.youngService.DTO;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

// 간단한 메시지 DTO
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MessageDTO {
    private String id;
    private String message;
    private String sender;
    private LocalDateTime timestamp;
    private int count;

    // 편의 메서드
    public static MessageDTO create(String message, String sender) {
        return MessageDTO.builder()
                .id(UUID.randomUUID().toString())
                .message(message)
                .sender(sender)
                .timestamp(LocalDateTime.now())
                .count(1)
                .build();
    }
}
