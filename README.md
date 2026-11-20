# Claude 开机动画 · 终端 / CloudCLI 版

> 基于 [wynneceles/ai-boot-animations](https://github.com/wynneceles/ai-boot-animations) 的 Windows 版修改。
> 原版只支持 **Claude 桌面端**，这个版本让没有桌面端的人也能用：在 **终端里启动 Claude Code** 或 **打开 CloudCLI** 时播放开机动画。

非官方同人项目，与 Anthropic 无关。Claude 是 Anthropic 的商标。

## 效果

- 🎬 **开屏动画**：在终端里输入 `claude` 回车，或者打开 CloudCLI，窗口上先播放一段约 11 秒的开屏动画（带音效和字幕）
- 🌙 **循环背景**：开屏结束后变成半透明的动态背景，鼠标点击会穿透下去，不影响打字和操作
- 👋 **自动收起**：退出 Claude Code（或关掉终端 / CloudCLI）时，动画自动淡出
- ⏭ **随时跳过**：开屏时右上角有「跳过」
- 🧼 **不改任何程序**：它是一个独立的小程序，盖在窗口上方播放；卸载后什么都不留

## 支持哪些情况

| 情况 | 会不会播放 |
|---|---|
| 在 Windows Terminal 里运行 `claude` | ✅ 播放在那个终端窗口上 |
| 在旧版控制台（cmd / PowerShell 窗口）里运行 `claude` | ✅ 播放在当前窗口上 |
| 打开 CloudCLI | ✅ 播放在 CloudCLI 窗口上 |
| 打开 Claude 桌面端 | ✅ 和原版一样 |
| CloudCLI / VS Code / Cursor 在后台启动的 Claude Code | ❌ 不播放，避免反复弹出 |
| 小程序启动时就已经开着的窗口 | ❌ 不补播（可以手动「播放一次开屏动画」） |

需要 **Windows 10 或 11**。macOS 请用[原版](https://github.com/wynneceles/ai-boot-animations)。

## 安装

### 方法一：一行命令（推荐）

打开 **PowerShell**（开始菜单搜索 PowerShell，**不需要**管理员），粘贴下面这一行，回车：

```powershell
[Net.ServicePointManager]::SecurityProtocol='Tls12'; irm https://raw.githubusercontent.com/kooboven-commits/claude-boot-animation-cli/main/web-install.ps1 | iex
```

它会：

1. 下载本仓库的源码
2. 从原作者的[官方发布 v1.1.0](https://github.com/wynneceles/ai-boot-animations/releases/tag/v1.1.0) 下载动画素材（约 36 MB），并核对 SHA256，不一致就停止安装
3. 用 Windows 自带的 C# 编译器现场编译（不用装任何 SDK）
4. 装到 `%LOCALAPPDATA%\Programs\ClaudeBootAnimation`，设为开机自启

装好后右下角托盘会出现 ✨ 图标，并弹出设置窗口。

### 方法二：下载源码安装

1. 点本页上方绿色的 **Code → Download ZIP**，解压
2. 在解压出来的文件夹里，空白处按住 Shift 右键 →「在此处打开 PowerShell 窗口」
3. 运行：

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

## 使用

### 什么时候播放

- 在终端里输入 `claude` 启动 Claude Code → 在那个终端窗口上播放
- 打开 CloudCLI → 在 CloudCLI 窗口上播放
- 同时开着好几个终端窗口时，会播放在你敲 `claude` 时最前面的那个窗口上

### 托盘 ✨ 菜单

右键右下角的 ✨（Windows 11 如果没看到，点任务栏右侧的 `^` 展开）：

| 菜单项 | 作用 |
|---|---|
| 播放开屏动画 / 保留循环背景 | 两个开关，决定打开时放什么（都关掉 = 什么都不放） |
| 背景不透明度 | 循环背景有多浓，0–80%，默认 25%。挡字就调低 |
| 开屏音量 | 开屏音效的音量 |
| 播放一次开屏动画 | 马上在当前的 CloudCLI / 终端窗口上放一次 |
| 开启循环背景 / 关掉 | 马上开启或收起当前的动画 |
| 打开设置文件… | 改字幕文字、时间等更细的参数 |
| 卸载… | 一键删干净 |

### 命令行参数

```powershell
# 重启小程序并马上在当前窗口上播放一次
Stop-Process -Name ClaudeBootAnimation -ErrorAction SilentlyContinue
& "$env:LOCALAPPDATA\Programs\ClaudeBootAnimation\ClaudeBootAnimation.exe" --play-now
```

### 设置文件

`%APPDATA%\ClaudeBootAnimation\config.json`，改完保存，下次播放生效：

| 键 | 默认 | 含义 |
|---|---|---|
| `playIntro` / `loopBackground` | true / true | 同菜单里的两个开关 |
| `residualAlpha` | 0.25 | 循环背景不透明度 |
| `introVolume` | 1.0 | 开屏音量 |
| `showSubtitles` | true | 是否显示字幕 |
| `subtitles` | 两句英文 | 字幕文字和起止秒数 |

日志：`%LOCALAPPDATA%\ClaudeBootAnimation\log.txt`

## 卸载

托盘 ✨ 右键 →「卸载 Claude 开机动画…」，或者在 PowerShell 里运行：

```powershell
powershell -ExecutionPolicy Bypass -File "$env:LOCALAPPDATA\Programs\ClaudeBootAnimation\uninstall.ps1"
```

会删除小程序、开机自启、设置和日志。

## 常见问题

**打开终端运行 claude 没有播放？**
小程序要先在运行（托盘里有 ✨）。另外，小程序启动之前就已经开着的 Claude Code 不会补播，重新运行一次 `claude` 就行。

**背景挡住了字？**
托盘 ✨ → 把「背景不透明度」调低，或者关掉「保留循环背景」，只留开屏。

**占多少资源？**
后台常驻约 90 MB 内存；没有播放时几乎不占 CPU。

**会不会读我的终端内容？**
不会。它只读取窗口的位置和大小，以及进程名和父进程（用来判断 claude 是不是从终端启动的），不读窗口标题和内容，也不联网（只有安装时下载一次素材）。

## 和原版相比改了什么

全部改动都在 `src/ClaudeBootAnimation.cs`：

- 识别窗口时除了 Claude 桌面端，也接受 `CloudCLI` 进程的窗口
- 新增 `Finder.FindTerminal`：发现新的 `claude.exe` 命令行进程时，沿父进程往上找它所在的 Windows Terminal 窗口（找不到就用前台的终端窗口）；跳过由 CloudCLI、Claude 桌面端、VS Code、Cursor 或另一个 claude 启动的进程；跳过最小化后藏在屏幕外的窗口
- Claude Code 进程退出时，动画自动淡出
- 新增 `--play-now` 启动参数
- `install.ps1` 改为从原作者的官方发布下载动画素材并核对 SHA256，本仓库不包含任何动画素材

## 授权与致谢

- **代码**：[GPL-3.0](LICENSE)。原作者 wynneceles（[ai-boot-animations](https://github.com/wynneceles/ai-boot-animations)），本仓库在其基础上修改，同样以 GPL-3.0 发布
- **动画素材**：不在本仓库中，安装时从原作者的官方发布下载，授权为 [CC BY-NC-ND 4.0](https://github.com/wynneceles/ai-boot-animations/blob/main/claude/assets/LICENSE.md)：可以自己使用、原样分享，**不能商用、不能修改后再发布**。分镜与动作设计由 wynneceles 完成，画面由 Seedance 生成；角色是网上流传的「克劳德」拟人形象，著作权归原设计者
- **字体**：Libre Bodoni（SIL OFL），随素材一起下载
- **音效**：Freesound CC0 素材，见原仓库的 [CREDITS.md](https://github.com/wynneceles/ai-boot-animations/blob/main/claude/CREDITS.md)

---

**English (short):** A Windows fork of [wynneceles/ai-boot-animations](https://github.com/wynneceles/ai-boot-animations) that plays the Claude boot animation when you start **Claude Code in a terminal** (`claude`) or open **CloudCLI**, not only the Claude desktop app. Install with the one-liner above (no admin rights). Animation assets are downloaded from the original author's release at install time (CC BY-NC-ND 4.0) and are not included here. Code is GPL-3.0. Unofficial fan project, not affiliated with Anthropic.
