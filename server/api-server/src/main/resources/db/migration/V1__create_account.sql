-- V1: Tài khoản đăng nhập
-- updated_at được cập nhật phía ứng dụng (@UpdateTimestamp trong JPA)

CREATE TABLE account (
    id             BIGSERIAL     PRIMARY KEY,
    username       VARCHAR(20)   NOT NULL,
    email          VARCHAR(255)  NOT NULL,
    password_hash  VARCHAR(60)   NOT NULL,              -- BCrypt luôn dài 60 ký tự
    role           VARCHAR(10)   NOT NULL DEFAULT 'USER'
                   CHECK (role IN ('USER', 'ADMIN')),
    status         VARCHAR(10)   NOT NULL DEFAULT 'ACTIVE'
                   CHECK (status IN ('ACTIVE', 'BANNED')),
    last_login_at  TIMESTAMPTZ,
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT uq_account_username UNIQUE (username),
    CONSTRAINT uq_account_email    UNIQUE (email)
);

-- Đăng nhập không phân biệt hoa thường: "Trieu" và "trieu" là một
CREATE UNIQUE INDEX uq_account_username_lower ON account (LOWER(username));
CREATE UNIQUE INDEX uq_account_email_lower    ON account (LOWER(email));
