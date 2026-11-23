package com.linhdienky.common.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.Date;

/**
 * Tạo và xác thực JWT. Dùng chung cho api-server và game-server.
 */
public class JwtService {

    private static final String CLAIM_ROLE = "role";

    private final SecretKey key;
    private final Duration accessTokenTtl;
    private final Clock clock;

    public JwtService(String secret, long accessTokenMinutes, Clock clock) {
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.accessTokenTtl = Duration.ofMinutes(accessTokenMinutes);
        this.clock = clock;
    }

    public JwtService(String secret, long accessTokenMinutes) {
        this(secret, accessTokenMinutes, Clock.systemUTC());
    }

    public String generateAccessToken(long accountId, String role) {
        Instant now = clock.instant();
        Instant expiration = now.plus(accessTokenTtl);

        return Jwts.builder()
                .subject(Long.toString(accountId))
                .claim(CLAIM_ROLE, role)
                .issuedAt(Date.from(now))
                .expiration(Date.from(expiration))
                .signWith(key)
                .compact();
    }

    public long getAccessTokenTtlSeconds() {
        return accessTokenTtl.toSeconds();
    }

    public JwtClaims parse(String token) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(key)
                    .clock(() -> Date.from(clock.instant()))
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();

            long accountId = Long.parseLong(claims.getSubject());
            String role = claims.get(CLAIM_ROLE, String.class);
            return new JwtClaims(accountId, role);
        } catch (ExpiredJwtException ex) {
            throw new InvalidTokenException(InvalidTokenException.Reason.EXPIRED, ex);
        } catch (SignatureException ex) {
            throw new InvalidTokenException(InvalidTokenException.Reason.INVALID_SIGNATURE, ex);
        } catch (JwtException | IllegalArgumentException ex) {
            throw new InvalidTokenException(InvalidTokenException.Reason.MALFORMED, ex);
        }
    }
}
