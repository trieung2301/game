package com.linhdienky.api.account;

/**
 * Trạng thái tài khoản.
 * Phải khớp với CHECK (status IN ('ACTIVE', 'BANNED')) trong V1__create_account.sql
 */
public enum AccountStatus {
    ACTIVE,
    BANNED
}
