# 一行命令安装（Windows 10 / 11，PowerShell）：
#   irm https://raw.githubusercontent.com/kooboven-commits/claude-boot-animation-cli/main/web-install.ps1 | iex
# 下载本仓库源码 → 运行 install.ps1（它会再去原作者的官方发布下载动画素材并编译安装）
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$repo = 'kooboven-commits/claude-boot-animation-cli'
$tmp = Join-Path $env:TEMP ('cba-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
    Write-Host "Downloading $repo ..."
    Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/$repo/archive/refs/heads/main.zip" -OutFile "$tmp\src.zip"
    Expand-Archive -Path "$tmp\src.zip" -DestinationPath "$tmp\src" -Force
    $root = Get-ChildItem "$tmp\src" -Directory | Select-Object -First 1
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root.FullName 'install.ps1')
}
finally {
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
