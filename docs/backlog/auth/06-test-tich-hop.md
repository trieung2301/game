# [Auth] Test tích hợp cho luồng xác thực

**Ước lượng:** 5 · **Ưu tiên:** Medium

### Acceptance Criteria
- [ ] Unit test `AuthService` (Mockito): đăng ký thành công, trùng username, trùng email, đăng nhập sai, bị khóa
- [ ] Integration test (Testcontainers Postgres + Redis): đăng ký → đăng nhập → `/me` → refresh → logout
- [ ] `mvn verify` xanh trên GitHub Actions
