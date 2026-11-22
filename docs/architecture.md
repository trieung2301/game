# Kiến trúc

```
Unity Client ──HTTP/REST──► api-server (Spring Boot :8080) ──► PostgreSQL
     │                                                     ├─► Redis
     └──TCP/Protobuf──► game-server (Netty :7000) ─────────┴─► RabbitMQ
React Web ──HTTP/REST──► api-server
```

**Luồng đăng nhập:** Client gọi `POST /api/auth/login` để nhận JWT → kết nối TCP tới game-server
→ gửi `LoginRequest{token}` → game-server xác thực bằng module `common`.

## Quy ước
- Java chia package theo tính năng. Mỗi package có `Controller → Service → Repository → Entity` và `dto/`.
- Không trả Entity ra API, luôn qua DTO.
- Thay đổi DB chỉ qua Flyway (`db/migration/V{n}__mo_ta.sql`).
