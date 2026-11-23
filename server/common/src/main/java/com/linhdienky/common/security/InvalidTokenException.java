package com.linhdienky.common.security;

public class InvalidTokenException extends RuntimeException {
    public enum Reason {
        EXPIRED,
        INVALID_SIGNATURE,
        MALFORMED
    }

    private final Reason reason;

    public InvalidTokenException(Reason reason, Throwable cause) {
        super("Token không hợp lệ: " + reason, cause);
        this.reason = reason;
    }

    public Reason getReason() {
        return reason;
    }
}
