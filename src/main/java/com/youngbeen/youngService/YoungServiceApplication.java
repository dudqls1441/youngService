package com.youngbeen.youngService;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.youngbeen.youngService.Mapper")
public class YoungServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(YoungServiceApplication.class, args);
	}
}