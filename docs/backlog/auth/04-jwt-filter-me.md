# [Auth] JWT filter và API lấy thông tin bản thân

**Ước lượng:** 3 · **Ưu tiên:** High · **Blocked by:** đăng nhập

### Chi tiết kỹ thuật
- `JwtAuthFilter extends OncePerRequestFilter`, gắn vào `SecurityConfig`
- `GET /api/accounts/me`

### Acceptance Criteria
- [ ] Header `Authorization: Bearer <token>` hợp lệ → vào được API cần đăng nhập
- [ ] Không có token / token sai / hết hạn → 401 JSON
- [ ] `/accounts/me` trả về thông tin tài khoản đang đăng nhập
- [ ] Token của tài khoản đã bị BANNED → 403
- [ ] Swagger: bấm Authorize, dán token, gọi được `/accounts/me`
