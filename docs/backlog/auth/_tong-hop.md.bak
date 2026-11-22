# Backlog: Giai đoạn Auth

> Mỗi mục dưới đây = 1 GitHub Issue. Copy nội dung vào Issue khi bắt đầu làm.
> Đã xong: khung project, database V1–V12, Entity Account, xử lý lỗi chung, Security cơ bản.

---

## [Auth] API đăng ký tài khoản
**Ước lượng:** 3 · **Ưu tiên:** High

### User story
Là người chơi mới, tôi muốn đăng ký tài khoản bằng username, email, mật khẩu để đăng nhập vào game.

### Chi tiết kỹ thuật
`POST /api/auth/register`
```json
Request:      { "username": "trieu", "email": "trieu@gmail.com", "password": "123456" }
Response 201: { "success": true, "data": { "id": 1, "username": "trieu", "email": "trieu@gmail.com", "role": "USER", "createdAt": "..." } }
```

### Acceptance Criteria
- [ ] Username 4–20 ký tự, chỉ gồm chữ, số, `_`
- [ ] Email đúng định dạng, lưu dạng chữ thường
- [ ] Mật khẩu 6–72 ký tự
- [ ] Username hoặc email trùng (không phân biệt hoa thường) → 409 `USERNAME_TAKEN` / `EMAIL_TAKEN`
- [ ] Dữ liệu sai → 400 `VALIDATION_ERROR`, message chỉ rõ field lỗi
- [ ] Mật khẩu lưu dạng BCrypt; response không chứa mật khẩu

---

## [Auth] JwtService: tạo và xác thực token
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

---

## [Auth] API đăng nhập
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

---

## [Auth] JWT filter và API lấy thông tin bản thân
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

---

## [Auth] Refresh token và đăng xuất
**Ước lượng:** 5 · **Ưu tiên:** Medium · **Blocked by:** JWT filter

### Chi tiết kỹ thuật
- Refresh token: chuỗi ngẫu nhiên (UUID), lưu Redis: key `refresh:{token}` → accountId, TTL 7 ngày
- `POST /api/auth/refresh` `{ "refreshToken": "..." }`
- `POST /api/auth/logout` `{ "refreshToken": "..." }`

### Acceptance Criteria
- [ ] Refresh hợp lệ → cấp access token mới + refresh token mới; token cũ bị xóa (xoay vòng)
- [ ] Dùng lại refresh token cũ → 401
- [ ] Đăng xuất → refresh token bị xóa khỏi Redis

---

## [Auth] Test tích hợp cho luồng xác thực
**Ước lượng:** 5 · **Ưu tiên:** Medium

### Acceptance Criteria
- [ ] Unit test `AuthService` (Mockito): đăng ký thành công, trùng username, trùng email, đăng nhập sai, bị khóa
- [ ] Integration test (Testcontainers Postgres + Redis): đăng ký → đăng nhập → `/me` → refresh → logout
- [ ] `mvn verify` xanh trên GitHub Actions

---

## [Auth] Giới hạn số lần đăng nhập sai
**Ước lượng:** 3 · **Ưu tiên:** Low

### Acceptance Criteria
- [ ] Sai mật khẩu 5 lần trong 15 phút → khóa đăng nhập 15 phút cho username đó
- [ ] Đếm bằng Redis (key có TTL)
- [ ] Trả về 429 `TOO_MANY_ATTEMPTS` kèm số giây còn lại
- [ ] Đăng nhập thành công → reset bộ đếm
