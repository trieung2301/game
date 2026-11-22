# client (Unity 6)

Thư mục này dành cho project Unity. Tạo bằng Unity Hub:

1. Unity Hub → **Projects → New project**
2. Chọn template **Universal 2D**
3. **Project name:** `client`, **Location:** `D:\Projects\TuTien`
   (Unity sẽ tạo project ngay trong thư mục này. Nếu báo thư mục không trống, tạm chuyển file README này ra ngoài rồi tạo lại.)
4. Sau khi tạo, dựng cấu trúc trong `Assets/`:

```
Assets/
├── _Project/
│   ├── Scripts/
│   │   ├── Core/          GameManager, Bootstrap
│   │   ├── Network/       ApiClient (HTTP), TcpClient, PacketDispatcher
│   │   ├── Protocol/      C# sinh từ /proto (tools/gen-proto.ps1)
│   │   ├── Gameplay/      Player, Farm, Alchemy, Dungeon
│   │   ├── UI/            LoginView, HudView, InventoryView...
│   │   ├── Data/          Model, định nghĩa ScriptableObject
│   │   └── LinhDienKy.asmdef
│   ├── Scenes/            Boot, Login, Village, Farm, Dungeon
│   ├── Prefabs/
│   ├── Art/               Sprites, Tilesets, UI, Animations
│   ├── Audio/
│   ├── ScriptableObjects/ Items, Herbs, Recipes, Realms
│   └── Tests/
├── Plugins/               Google.Protobuf.dll
└── ThirdParty/            Asset tải về (ghi rõ license)
```

Trong Unity: **Edit → Preferences → External Tools → External Script Editor → Visual Studio Code**.
