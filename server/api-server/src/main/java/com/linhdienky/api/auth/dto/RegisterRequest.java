package com.linhdienky.api.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/**
 * Dữ liệu client gửi lên khi đăng ký.
 *
 * DTO (Data Transfer Object) = object chỉ dùng để truyền dữ liệu qua API.
 * KHÔNG dùng thẳng Entity Account làm request vì:
 * - Client có thể gửi kèm "role": "ADMIN" -> tự phong admin!
 * - Tách riêng để kiểm soát chính xác field nào được nhận.
 *
 * Các @ kiểm tra dữ liệu (validation). Vi phạm -> GlobalExceptionHandler trả
 * lỗi 400.
 */
public record RegisterRequest(

        @NotBlank(message = "không được để trống")
        @Size(min = 4, max = 20, message = "phải từ 4 đến 20 ký tự")
        @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "chỉ gồm chữ, số và dấu gạch dưới")
        String username,

        @NotBlank(message = "không được để trống")
        @Email(message = "không đúng định dạng")
        @Size(max = 255, message = "không quá 255 ký tự")
        String email,

        // BCrypt chỉ xử lý tối đa 72 byte
        @NotBlank(message = "không được để trống")
        @Size(min = 6, max = 72, message = "phải từ 6 đến 72 ký tự")
        String password
) {
}
