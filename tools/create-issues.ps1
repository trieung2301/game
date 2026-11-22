# Tạo GitHub Issue từ các file ticket trong docs/backlog/<thư mục>
# Mỗi file: dòng đầu "# Tiêu đề", phần còn lại là nội dung Issue.
# Ticket nào đã có Issue cùng tiêu đề thì bỏ qua (chạy lại nhiều lần không bị trùng).
#
# Cần GitHub CLI:  winget install GitHub.cli   rồi   gh auth login
# Chạy từ thư mục gốc repo:  .\tools\create-issues.ps1 auth

param([string]$Folder = "auth")

$dir = "docs/backlog/$Folder"
if (-not (Test-Path $dir)) { Write-Host "Không tìm thấy $dir"; exit 1 }

$existing = gh issue list --state all --limit 500 --json title --jq ".[].title"

Get-ChildItem $dir -Filter *.md | Sort-Object Name | ForEach-Object {
    $lines = Get-Content $_.FullName -Encoding UTF8
    $title = $lines[0].TrimStart('#').Trim()

    if ($existing -contains $title) {
        Write-Host "Bỏ qua (đã có): $title"
        return
    }

    $bodyFile = New-TemporaryFile
    [IO.File]::WriteAllLines($bodyFile, ($lines | Select-Object -Skip 1), (New-Object Text.UTF8Encoding $false))
    gh issue create --title $title --body-file $bodyFile --assignee "@me" --label "enhancement"
    Remove-Item $bodyFile
}
