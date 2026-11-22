package com.linhdienky.common.security;

/**
 * Thông tin đọc ra từ JWT sau khi xác thực thành công.
 */
public record JwtClaims(
        long accountId,
        String role
) {
}
