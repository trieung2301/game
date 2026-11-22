# [Auth] Giới hạn số lần đăng nhập sai

**Ước lượng:** 3 · **Ưu tiên:** Low

### Acceptance Criteria
- [ ] Sai mật khẩu 5 lần trong 15 phút → khóa đăng nhập 15 phút cho username đó
- [ ] Đếm bằng Redis (key có TTL)
- [ ] Trả về 429 `TOO_MANY_ATTEMPTS` kèm số giây còn lại
- [ ] Đăng nhập thành công → reset bộ đếm
