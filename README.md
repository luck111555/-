# PaperCat Serial

一个基于 `PySide6 + pyserial + pyqtgraph` 的串口调试与波形显示工具，支持终端收发、协议解析、实时曲线、通道统计与数据导入导出。

## 功能概览

- 串口连接管理：端口自动扫描、波特率/数据位/校验位/停止位配置。
- 终端模式：文本接收、快速发送、发送计数/接收计数统计。
- 示波器模式：多通道实时曲线绘制、图例、网格、缩放与数据统计。
- 协议解析：支持多种数据格式与正则解析规则。
- 数据能力：录制、导入、导出（CSV/文本）。
- 界面优化：已移除背景插入渲染逻辑，降低重绘开销，提升拖动和缩放流畅性。

## 目录说明

- `tst.py`：主程序入口。
- `requirements.txt`：Python 依赖列表。
- `tst.spec`：PyInstaller 打包配置。
- `自动打包.bat`：Windows 一键打包脚本。
- `自动打包.sh`：Linux/WSL 打包脚本（在 WSL 下可调用 Windows PyInstaller）。
- `dist/`：打包输出目录（`PaperCat_Serial.exe`）。
- `backup/`：旧版本备份目录。
- `1.jpg`：历史资源文件（当前性能优化版本不依赖背景渲染）。

## 环境要求

- Windows 10/11（推荐）
- Python 3.10+（项目已在 Python 3.12 环境打包）
- 可用串口设备（USB 转串口、开发板等）

## 开发环境运行

1. 创建并激活虚拟环境（Windows）：

```bash
python -m venv .venv
.\.venv\Scripts\activate
```

2. 安装依赖：

```bash
pip install -r requirements.txt
```

3. 启动程序：

```bash
python tst.py
```

## 打包 EXE

### Windows（推荐）

直接运行：

```bat
自动打包.bat
```

脚本会执行以下动作：

1. 备份旧版 `dist/PaperCat_Serial.exe` 到 `backup/`。
2. 清理 `build/` 和 `dist/`。
3. 使用 `.venv\Scripts\pyinstaller.exe` 基于 `tst.spec` 打包。
4. 复制资源文件到 `dist/`。
5. 覆盖更新目标 EXE：`D:\项目资料\rt\dist\PaperCat_Serial.exe`。

### WSL/Linux

```bash
bash 自动打包.sh
```

在 WSL 环境下，脚本优先调用 Windows 虚拟环境中的 PyInstaller 以生成 Windows 可执行文件。

## 常见问题

### 1. 找不到串口

- 检查驱动是否安装完成。
- 确认设备管理器中端口号是否变化。
- 拔插设备后等待 2-3 秒再连接。

### 2. 打包失败（找不到 pyinstaller）

先在虚拟环境安装：

```bash
.\.venv\Scripts\python.exe -m pip install pyinstaller
```

### 3. 推送 GitHub 时提示大文件

当前仓库包含 `dist/*.exe` 和 `backup/*.exe`，单文件约 60MB+，会触发 GitHub 大文件警告。建议：

- 仅在 Release 上传 EXE；
- 或使用 Git LFS 管理二进制文件；
- 普通源码提交中排除 `dist/` 和 `backup/`。

## 依赖列表

来自 `requirements.txt`：

- `pyserial==3.5`
- `PySide6>=6.5.0`
- `pyqtgraph>=0.13.0`
- `numpy>=1.24.0`

## 许可说明

当前仓库未包含单独 License 文件。如需开源发布，建议补充 `LICENSE`（例如 MIT）。
