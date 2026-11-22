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
 *
 * JWT gồm 3 phần ngăn bởi dấu chấm:  header.payload.signature
 *   - payload: dữ liệu (accountId, role, thời hạn), AI CŨNG ĐỌC ĐƯỢC (chỉ mã hóa base64)
 *     -> tuyệt đối không bỏ mật khẩu, email... vào token
 *   - signature: chữ ký tạo từ secret. Sửa payload mà không có secret -> chữ ký sai -> bị từ chối
 *
 * Class này là Java thuần (không có @Service) vì module common không phụ thuộc Spring.
 * api-server sẽ tạo nó bằng @Bean trong 1 class cấu hình.
 *
 * Clock: "đồng hồ" có thể thay thế. Code thật dùng giờ hệ thống,
 * còn unit test truyền đồng hồ giả để thử token hết hạn mà không phải chờ 30 phút.
 */
public class JwtService {

    private static final String CLAIM_ROLE = "role";

    private final SecretKey key;
    private final Duration accessTokenTtl;
    private final Clock clock;

    public JwtService(String secret, long accessTokenMinutes, Clock clock) {
        // HS256 yêu cầu secret tối thiểu 32 byte, ngắn hơn thư viện sẽ báo lỗi
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.accessTokenTtl = Duration.ofMinutes(accessTokenMinutes);
        this.clock = clock;
    }

    /** Constructor dùng giờ hệ thống thật */
    public JwtService(String secret, long accessTokenMinutes) {
        this(secret, accessTokenMinutes, Clock.systemUTC());
    }

    /**
     * Tạo access token.
     *
     * @return chuỗi JWT dạng "eyJhbGciOi..."
     */
    public String generateAccessToken(long accountId, String role) {
        Instant now = clock.instant();
        Instant expiresAt = now.plus(accessTokenTtl);

        // TODO: dùng Jwts.builder() để tạo token:
        //   .subject(...)          -> String.valueOf(accountId)
        //   .claim(CLAIM_ROLE, role)
        //   .issuedAt(...)         -> Date.from(now)
        //   .expiration(...)       -> Date.from(expiresAt)
        //   .signWith(key)
        //   .compact()             -> trả về chuỗi token
        return null;
    }

    /** Thời hạn access token tính bằng giây (trả về cho client biết khi nào cần refresh) */
    public long getAccessTokenTtlSeconds() {
        return accessTokenTtl.toSeconds();
    }

    /**
     * Kiểm tra chữ ký + thời hạn, rồi đọc thông tin trong token.
     *
     * @throws InvalidTokenException nếu token không dùng được
     */
    public JwtClaims parse(String token) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(key)                                // kiểm tra chữ ký bằng secret
                    .clock(() -> Date.from(clock.instant()))        // dùng đồng hồ của mình để so thời hạn
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();

            // TODO: đọc dữ liệu từ claims và trả về new JwtClaims(...)
            //   accountId: claims.getSubject() là String -> đổi sang long bằng Long.parseLong(...)
            //   role:      claims.get(CLAIM_ROLE, String.class)
            return null;

        } catch (ExpiredJwtException e) {
            throw new InvalidTokenException(InvalidTokenException.Reason.EXPIRED, e);
        } catch (SignatureException e) {
            throw new InvalidTokenException(InvalidTokenException.Reason.INVALID_SIGNATURE, e);
        } catch (JwtException | IllegalArgumentException e) {
            // JwtException: các lỗi jjwt còn lại (sai định dạng...)
            // IllegalArgumentException: token null hoặc rỗng
            throw new InvalidTokenException(InvalidTokenException.Reason.MALFORMED, e);
        }
    }
}
