package com.linhdienky.api.account.dto;

import com.linhdienky.api.account.Account;

import java.time.Instant;

/**
 * Dữ liệu tài khoản trả về cho client.
 * KHÔNG BAO GIỜ trả passwordHash ra ngoài -> không có field đó ở đây.
 */
public record AccountResponse(
        Long id,
        String username,
        String email,
        String role,
        Instant createdAt
) {
    /** Chuyển Entity -> DTO. Dùng: AccountResponse.from(account) */
    public static AccountResponse from(Account account) {
        return new AccountResponse(
                account.getId(),
                account.getUsername(),
                account.getEmail(),
                account.getRole().name(),   // enum -> chuỗi "USER"
                account.getCreatedAt()
        );
    }
}
