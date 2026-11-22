package com.linhdienky.api.account;

/**
 * Vai trò của tài khoản.
 * Phải khớp với CHECK (role IN ('USER', 'ADMIN')) trong V1__create_account.sql
 */
public enum Role {
    USER,   // người chơi thường
    ADMIN   // quản trị viên: được vào trang admin
}
