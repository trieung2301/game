package com.linhdienky.api.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.linhdienky.api.common.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Cấu hình bảo mật.
 *
 * Ý tưởng: API dùng JWT, KHÔNG dùng session/cookie như web truyền thống.
 *   - Client gửi token trong header "Authorization: Bearer <token>" ở MỌI request
 *   - Server không lưu trạng thái đăng nhập (STATELESS)
 *
 * @Configuration : class chứa cấu hình, Spring đọc khi khởi động
 * @Bean          : object do method trả về được Spring quản lý, nơi khác cần thì tự "tiêm" vào
 */
@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final ObjectMapper objectMapper;   // Dùng để ghi JSON khi trả lỗi 401

    /**
     * Các đường dẫn KHÔNG cần đăng nhập.
     * Lưu ý: không ghi "/api" ở đầu vì context-path đã là /api.
     */
    private static final String[] PUBLIC_PATHS = {
            "/auth/**",              // đăng ký, đăng nhập, refresh token
            "/swagger-ui.html",
            "/swagger-ui/**",
            "/v3/api-docs/**",
            "/actuator/health"
    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                // CSRF chỉ cần cho web dùng cookie. API dùng token nên tắt.
                .csrf(AbstractHttpConfigurer::disable)

                // Tắt form đăng nhập và HTTP Basic mặc định của Spring
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)

                .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // Phân quyền theo đường dẫn: đọc từ TRÊN xuống, khớp cái nào áp dụng cái đó
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(PUBLIC_PATHS).permitAll()      // ai cũng vào được
                        .requestMatchers("/admin/**").hasRole("ADMIN")  // chỉ ADMIN
                        .anyRequest().authenticated()                   // còn lại: phải đăng nhập
                )

                // Chưa đăng nhập mà gọi API cần đăng nhập -> trả 401 dạng JSON (thay vì trang HTML)
                .exceptionHandling(ex -> ex.authenticationEntryPoint((request, response, authException) -> {
                    response.setStatus(401);
                    response.setContentType(MediaType.APPLICATION_JSON_VALUE);
                    response.setCharacterEncoding("UTF-8");
                    objectMapper.writeValue(response.getWriter(),
                            ApiResponse.error("UNAUTHORIZED", "Vui lòng đăng nhập"));
                }));

        // Bước 8 sẽ thêm: .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)

        return http.build();
    }

    /**
     * Bộ mã hóa mật khẩu BCrypt.
     *   encode("123456")              -> "$2a$10$N9qo8uLOickgx2ZMRZoMy..." (60 ký tự, mỗi lần khác nhau)
     *   matches("123456", chuoiHash)  -> true/false
     * Không thể giải mã ngược từ hash ra mật khẩu gốc.
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
