# 批量解压工具 (Batch Unzip Tool)

这是一个跨平台的批量 ZIP 文件解压工具，支持 Windows、macOS 和 Linux 系统。

## 功能特点

- 支持批量处理多个目录中的 ZIP 文件
- 可以指定统一的输出目录
- 自动创建以 ZIP 文件名命名的子目录
- 显示详细的处理进度和统计信息
- 跨平台支持（Windows、macOS、Linux）

## 系统要求

- bash shell 环境
  - Windows: Git Bash、Cygwin 或 MSYS2
  - macOS: 内置终端
  - Linux: 任何终端
- unzip 命令行工具
- find 命令（通常已预装）

## 安装依赖

### Windows
1. 安装 [Git for Windows](https://gitforwindows.org/)（推荐）或 [Cygwin](https://www.cygwin.com/) 或 [MSYS2](https://www.msys2.org/)
2. 确保安装了 unzip 工具（Git Bash 通常已包含）

### macOS
如果没有 unzip 命令，使用 Homebrew 安装：
```bash
brew install unzip
```

### Linux
Ubuntu/Debian:
```bash
sudo apt-get install unzip
```

CentOS/RHEL:
```bash
sudo yum install unzip
```

## 使用方法

1. 下载脚本：
```bash
curl -O http://139.196.236.11/browser/fintool/batch_unzip_script%2F
chmod +x batch_unzip.sh
```

2. 基本用法（在原地解压）：
```bash
./batch_unzip.sh 目录1 目录2
```

3. 指定输出目录：
```bash
./batch_unzip.sh -o 输出目录 目录1 目录2
```

4. 查看帮助：
```bash
./batch_unzip.sh -h
```

## 示例

1. 解压单个目录中的所有 ZIP 文件：
```bash
./batch_unzip.sh downloads
```

2. 解压多个目录中的 ZIP 文件到指定目录：
```bash
./batch_unzip.sh -o output downloads1 downloads2
```

## 注意事项

1. 在 Windows 系统上，请使用 Git Bash、Cygwin 或 MSYS2 运行脚本
2. 确保有足够的磁盘空间存放解压后的文件
3. 如果指定的输出目录不存在，脚本会自动创建
4. 脚本会自动处理不同操作系统的路径分隔符
