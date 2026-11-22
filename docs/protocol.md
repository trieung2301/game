# Giao thức game-server

Khung gói tin TCP: `[4 byte độ dài][2 byte mã lệnh][payload Protobuf]`

| Mã | Tên | Hướng | Message |
|---|---|---|---|
| 1 | LOGIN | C → S | LoginRequest |
| 2 | LOGIN_RESULT | S → C | LoginResponse |
