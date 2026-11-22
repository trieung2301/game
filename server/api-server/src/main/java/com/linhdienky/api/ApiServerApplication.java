package com.linhdienky.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration;

// Tắt tài khoản mặc định của Spring Security (mình tự xác thực bằng JWT)
@SpringBootApplication(exclude = UserDetailsServiceAutoConfiguration.class)
public class ApiServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiServerApplication.class, args);
    }
}
