# [Auth] Refresh token và đăng xuất

**Ước lượng:** 5 · **Ưu tiên:** Medium · **Blocked by:** JWT filter

### Chi tiết kỹ thuật
- Refresh token: chuỗi ngẫu nhiên (UUID), lưu Redis: key `refresh:{token}` → accountId, TTL 7 ngày
- `POST /api/auth/refresh` `{ "refreshToken": "..." }`
- `POST /api/auth/logout` `{ "refreshToken": "..." }`

### Acceptance Criteria
- [ ] Refresh hợp lệ → cấp access token mới + refresh token mới; token cũ bị xóa (xoay vòng)
- [ ] Dùng lại refresh token cũ → 401
- [ ] Đăng xuất → refresh token bị xóa khỏi Redis
