# [Auth] JwtService: tạo và xác thực token

**Ước lượng:** 3 · **Ưu tiên:** High

### User story
Là hệ thống, tôi cần tạo và kiểm tra JWT để xác định người dùng ở mỗi request, dùng chung cho api-server và game-server.

### Chi tiết kỹ thuật
- Đặt trong module `common`: `com.linhdienky.common.security.JwtService`
- Thư viện jjwt 0.12, thuật toán HS256, secret đọc từ `app.jwt.secret`
- Claims: `sub` = accountId, `role`, `iat`, `exp`

### Acceptance Criteria
- [ ] `generateAccessToken(accountId, role)` hết hạn sau `app.jwt.access-token-minutes`
- [ ] `parse(token)` trả về accountId + role
- [ ] Token sai chữ ký / hết hạn / sai định dạng → ném exception riêng, không crash
- [ ] Unit test đủ 4 trường hợp: hợp lệ, hết hạn, bị sửa, sai định dạng
