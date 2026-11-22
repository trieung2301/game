package com.linhdienky.common.security;

/**
 * Token không dùng được: sai chữ ký, hết hạn, sai định dạng, rỗng...
 * Nơi gọi chỉ cần bắt 1 loại lỗi này thay vì nhiều loại lỗi của thư viện jjwt.
 */
public class InvalidTokenException extends RuntimeException {

    /** Lý do cụ thể, phục vụ ghi log và test */
    public enum Reason { EXPIRED, INVALID_SIGNATURE, MALFORMED }

    private final Reason reason;

    public InvalidTokenException(Reason reason, Throwable cause) {
        super("Token không hợp lệ: " + reason, cause);
        this.reason = reason;
    }

    public Reason getReason() {
        return reason;
    }
}
