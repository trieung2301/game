# [Auth] API đăng nhập

**Ước lượng:** 3 · **Ưu tiên:** High · **Blocked by:** đăng ký, JwtService

### Chi tiết kỹ thuật
`POST /api/auth/login`
```json
Request:      { "username": "trieu", "password": "123456" }
Response 200: { "success": true, "data": { "accessToken": "...", "refreshToken": "...", "expiresIn": 1800 } }
```

### Acceptance Criteria
- [ ] Username không phân biệt hoa thường
- [ ] Sai username HOẶC sai mật khẩu → cùng một lỗi 401 `INVALID_CREDENTIALS` (không tiết lộ cái nào sai)
- [ ] Tài khoản BANNED → 403 `ACCOUNT_BANNED`
- [ ] Cập nhật `last_login_at`
