package com.linhdienky.api.common;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

/**
 * Danh sách mã lỗi nghiệp vụ của toàn hệ thống.
 *
 * Mỗi mã lỗi gồm:
 *  - HttpStatus: mã HTTP trả về (400 dữ liệu sai, 401 chưa đăng nhập, 403 không có quyền, 404 không tìm thấy, 409 trùng)
 *  - message:    thông báo tiếng Việt hiển thị cho người chơi
 *
 * Thêm lỗi mới: chỉ cần thêm 1 dòng ở đây.
 */
@Getter
@RequiredArgsConstructor   // Lombok: tự sinh constructor cho các field final
public enum ErrorCode {

    // ===== Chung =====
    VALIDATION_ERROR(HttpStatus.BAD_REQUEST, "Dữ liệu không hợp lệ"),
    INTERNAL_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi hệ thống, vui lòng thử lại sau"),

    // ===== Tài khoản =====
    USERNAME_TAKEN(HttpStatus.CONFLICT, "Tên đăng nhập đã tồn tại"),
    EMAIL_TAKEN(HttpStatus.CONFLICT, "Email đã được sử dụng"),
    INVALID_CREDENTIALS(HttpStatus.UNAUTHORIZED, "Sai tên đăng nhập hoặc mật khẩu"),
    ACCOUNT_BANNED(HttpStatus.FORBIDDEN, "Tài khoản đã bị khóa"),
    ACCOUNT_NOT_FOUND(HttpStatus.NOT_FOUND, "Không tìm thấy tài khoản");

    private final HttpStatus status;
    private final String message;
}
