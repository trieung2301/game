# [Auth] API đăng ký tài khoản

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
