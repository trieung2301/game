package com.linhdienky.api.common;

import lombok.Getter;

/**
 * Lỗi nghiệp vụ: lỗi do người dùng/luật game, KHÔNG phải bug.
 * Ví dụ: trùng username, sai mật khẩu, không đủ linh thạch.
 *
 * Cách dùng trong Service:
 *     if (accountRepository.existsByUsernameIgnoreCase(username)) {
 *         throw new BusinessException(ErrorCode.USERNAME_TAKEN);
 *     }
 *
 * GlobalExceptionHandler sẽ bắt lỗi này và trả JSON cho client.
 *
 * extends RuntimeException: không bắt buộc phải try/catch hay khai báo "throws".
 */
@Getter
public class BusinessException extends RuntimeException {

    private final ErrorCode errorCode;

    public BusinessException(ErrorCode errorCode) {
        super(errorCode.getMessage());   // Gọi constructor của RuntimeException để lưu message
        this.errorCode = errorCode;
    }
}
