# Linh Điền Ký

Game tu tiên điền viên online: top-down 2D, trồng linh dược, luyện đan, tu luyện, bí cảnh nhiều người chơi.

## Công nghệ

| Phần | Công nghệ |
|---|---|
| Server | Java 21, Spring Boot 3.5, Maven multi-module |
| Game server | Netty (TCP) + Protobuf |
| Database | PostgreSQL 16 + Flyway |
| Cache / Queue | Redis, RabbitMQ |
| Client | Unity 6 LTS (C#) |
| Web / Admin | React + TypeScript + Vite, Ant Design |
| DevOps | Docker Compose, GitHub Actions, Nginx, Prometheus |

## Cấu trúc

```
TuTien/
├── proto/          File .proto dùng chung cho Java và C#
├── server/         Maven multi-module
│   ├── common/       JWT, exception, util dùng chung
│   ├── protocol/     Sinh Java từ /proto
│   ├── api-server/   REST API (Spring Boot, :8080)
│   └── game-server/  Realtime (Netty, :7000)
├── client/         Unity project
├── web/            React web portal + admin
├── infra/          docker-compose, nginx, prometheus
├── tools/          Script tiện ích (sinh proto C#)
├── docs/           Thiết kế game, kiến trúc, DB, giao thức
└── .github/        CI
```

## Chạy ở máy local

**1. Hạ tầng (PostgreSQL, Redis, RabbitMQ):**
```powershell
docker compose -f infra/docker-compose.dev.yml up -d
```

**2. Server:**
```powershell
cd server
mvn clean install
mvn -pl api-server spring-boot:run
mvn -pl game-server spring-boot:run
```
API: http://localhost:8080/api · Swagger: http://localhost:8080/api/swagger-ui.html

**3. Web:**
```powershell
cd web
npm install
npm run dev
```

**4. Client:** mở thư mục `client/` bằng Unity Hub (xem `client/README.md`).

## Tài liệu
- [Game design](docs/game-design.md)
- [Kiến trúc](docs/architecture.md)
- [Database](docs/database.md)
- [Giao thức](docs/protocol.md)
