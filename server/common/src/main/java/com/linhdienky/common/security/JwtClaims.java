package com.linhdienky.common.security;

public record JwtClaims(
        long accountId,
        String role
) {
}
