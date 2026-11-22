package com.linhdienky.game;

import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;

@SpringBootApplication
public class GameServerApplication {

    public static void main(String[] args) {
        new SpringApplicationBuilder(GameServerApplication.class)
                .web(WebApplicationType.NONE) // Không chạy Tomcat, Netty tự mở cổng TCP
                .run(args);
    }
}
