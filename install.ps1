# Claude 开机动画（终端 / CloudCLI 版）安装脚本
# 1. 没有动画素材时，从原作者 wynneceles 的官方发布包下载（核对 SHA256，不对就停止）
# 2. 用 Windows 自带的 .NET Framework 编译器编译，不需要装任何 SDK
# 3. 装到 %LOCALAPPDATA%\Programs\ClaudeBootAnimation，设为开机自启，弹出设置窗口
# 不需要管理员权限，不修改 Claude、CloudCLI 或终端的任何文件。
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$AssetsUrl = 'https://github.com/wynneceles/ai-boot-animations/releases/download/v1.1.0/ClaudeBootAnimation-Windows.zip'
$AssetsSha256 = 'F271971BC8C74E7BA9566E31AA1074636C0108C8A9E382DEB3117B03934E624D'

$assets = Join-Path $PSScriptRoot 'assets'
if (-not (Test-Path (Join-Path $assets 'intro.mp4')) -or -not (Test-Path (Join-Path $assets 'loop.mp4'))) {
    Write-Host '正在下载动画素材（约 36 MB，来自原作者 wynneceles 的官方发布 v1.1.0）...'
    $tmp = Join-Path $env:TEMP ('cba-assets-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    try {
        Invoke-WebRequest -UseBasicParsing -Uri $AssetsUrl -OutFile "$tmp\pkg.zip"
        $hash = (Get-FileHash "$tmp\pkg.zip" -Algorithm SHA256).Hash
        if ($hash -ne $AssetsSha256) { throw "素材包校验失败（SHA256 = $hash），为了安全已停止安装。" }
        Expand-Archive -Path "$tmp\pkg.zip" -DestinationPath "$tmp\x" -Force
        New-Item -ItemType Directory -Force -Path $assets | Out-Null
        Copy-Item "$tmp\x\ClaudeBootAnimation-Windows\assets\*" $assets -Force
        Copy-Item "$tmp\x\ClaudeBootAnimation-Windows\ASSETS-LICENSE.md" $PSScriptRoot -Force
    }
    finally {
        Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
}

$dest = "$env:LOCALAPPDATA\Programs\ClaudeBootAnimation"
Get-Process ClaudeBootAnimation -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 500
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
& "$PSScriptRoot\build.ps1" -Out $dest
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'ClaudeBootAnimation' -Value "`"$dest\ClaudeBootAnimation.exe`""
Start-Process "$dest\ClaudeBootAnimation.exe" -ArgumentList '--settings'
Write-Host ''
Write-Host '✨ 装好了！右下角托盘出现 ✨ 图标，也弹出了设置窗口。'
Write-Host '   在终端里输入 claude 启动 Claude Code，或者打开 CloudCLI，就会播放开机动画。'
Write-Host '   想马上看：托盘 ✨ 右键 →「播放一次开屏动画」。'
