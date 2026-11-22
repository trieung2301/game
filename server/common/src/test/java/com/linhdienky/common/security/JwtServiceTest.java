package com.linhdienky.common.security;

import org.junit.jupiter.api.Test;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit test cho JwtService.
 *
 * Cấu trúc mỗi test (Arrange - Act - Assert):
 *   1. Chuẩn bị dữ liệu
 *   2. Gọi method cần test
 *   3. Kiểm tra kết quả
 *
 * Chạy:  cd server  ->  mvn -pl common test
 * Hoặc bấm nút ▷ cạnh tên method trong VS Code.
 */
class JwtServiceTest {

    private static final String SECRET = "test-secret-key-it-nhat-32-ky-tu-1234567890";

    // Đồng hồ giả: luôn chỉ đúng 1 thời điểm cố định
    private final Instant now = Instant.parse("2026-01-01T00:00:00Z");
    private final JwtService jwtService = new JwtService(SECRET, 30, Clock.fixed(now, ZoneOffset.UTC));

    @Test
    void tokenHopLe_docRaDungAccountIdVaRole() {
        // Act
        String token = jwtService.generateAccessToken(42L, "USER");
        JwtClaims claims = jwtService.parse(token);

        // Assert
        assertEquals(42L, claims.accountId());
        assertEquals("USER", claims.role());
    }

    @Test
    void tokenHetHan_nemLoiExpired() {
        String token = jwtService.generateAccessToken(42L, "USER");

        // Một JwtService khác có đồng hồ chạy nhanh hơn 31 phút -> token đã hết hạn
        JwtService future = new JwtService(SECRET, 30,
                Clock.fixed(now.plus(Duration.ofMinutes(31)), ZoneOffset.UTC));

        InvalidTokenException ex = assertThrows(InvalidTokenException.class, () -> future.parse(token));
        assertEquals(InvalidTokenException.Reason.EXPIRED, ex.getReason());
    }

    @Test
    void tokenBiSua_nemLoiChuKy() {
        // TODO: tạo token, rồi tạo 1 JwtService khác với SECRET khác (cũng dài >= 32 ký tự)
        //       parse token bằng service đó -> phải ném InvalidTokenException với Reason.INVALID_SIGNATURE
        //       Gợi ý: làm giống test tokenHetHan ở trên
    }

    @Test
    void tokenSaiDinhDang_nemLoiMalformed() {
        // TODO: parse chuỗi "abc.def" -> phải ném InvalidTokenException với Reason.MALFORMED
    }

    @Test
    void tokenRong_nemLoiMalformed() {
        // TODO: parse chuỗi "" -> phải ném InvalidTokenException với Reason.MALFORMED
    }
}
