package com.linhdienky.common.security;

import org.junit.jupiter.api.Test;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;

import static org.junit.jupiter.api.Assertions.*;

class JwtServiceTest {
    private static final String SECRET = "secret-dung-cho-test-dai-hon-32-ky-tu";
    private final Instant now = Instant.parse("2026-01-01T00:00:00Z");
    private final Clock clock = Clock.fixed(now, ZoneOffset.UTC);
    private final JwtService jwtService = new JwtService(SECRET, 30, clock);

    @Test
    void tokenHopLe_parseRaDungAccountIdVaRole() {
        String token = jwtService.generateAccessToken(42L, "USER");
        JwtClaims claims = jwtService.parse(token);

        assertEquals(42L, claims.accountId());
        assertEquals("USER", claims.role());
    }

    @Test
    void tokenHetHan_nemInvalidTokenExceptionReasonExpired() {
        String token = jwtService.generateAccessToken(42L, "USER");

        Clock laterClock = Clock.fixed(now.plus(Duration.ofMinutes(31)), ZoneOffset.UTC);
        JwtService laterService = new JwtService(SECRET, 30, laterClock);

        InvalidTokenException ex = assertThrows(
                InvalidTokenException.class,
                () -> laterService.parse(token)
        );
        assertEquals(InvalidTokenException.Reason.EXPIRED, ex.getReason());
    }

    @Test
    void tokenKySecretKhac_nemInvalidTokenExceptionReasonInvalidSignature() {
        String token = jwtService.generateAccessToken(42L, "USER");

        String otherSecret = "secret-khac-dung-cho-test-dai-hon-32-ky-tu";
        JwtService otherService = new JwtService(otherSecret, 30, clock);

        InvalidTokenException ex = assertThrows(
                InvalidTokenException.class,
                () -> otherService.parse(token)
        );
        assertEquals(InvalidTokenException.Reason.INVALID_SIGNATURE, ex.getReason());
    }

    @Test
    void chuoiAbcDef_nemInvalidTokenExceptionReasonMalformed() {
        InvalidTokenException ex = assertThrows(
                InvalidTokenException.class,
                () -> jwtService.parse("abc.def")
        );
        assertEquals(InvalidTokenException.Reason.MALFORMED, ex.getReason());
    }

    @Test
    void chuoiRong_nemInvalidTokenExceptionReasonMalformed() {
        InvalidTokenException ex = assertThrows(
                InvalidTokenException.class,
                () -> jwtService.parse("")
        );
        assertEquals(InvalidTokenException.Reason.MALFORMED, ex.getReason());
    }
}