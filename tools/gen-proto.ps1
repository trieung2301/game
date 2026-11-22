# Sinh code C# từ /proto vào Unity client.
# Cần protoc: winget install protobuf
# Chạy từ thư mục gốc repo:  .\tools\gen-proto.ps1
$out = "client/Assets/_Project/Scripts/Protocol"
New-Item -ItemType Directory -Force -Path $out | Out-Null
protoc --proto_path=proto --csharp_out=$out proto/*.proto
Write-Host "Da sinh C# vao $out"
