#!/usr/bin/env bash

# 检测操作系统类型
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux" ;;
        Darwin*)    echo "mac" ;;
        CYGWIN*)    echo "windows" ;;
        MINGW*)     echo "windows" ;;
        MSYS*)      echo "windows" ;;
        *)          echo "unknown" ;;
    esac
}

# 检查必要的命令
check_requirements() {
    local os=$(detect_os)
    # 检查 unzip 命令
    if ! command -v unzip &> /dev/null; then
        echo "错误: 未找到 unzip 命令"
        case "$os" in
            "linux")
                echo "请使用包管理器安装，例如:"
                echo "  Ubuntu/Debian: sudo apt-get install unzip"
                echo "  CentOS/RHEL: sudo yum install unzip"
                ;;
            "mac")
                echo "请使用 Homebrew 安装:"
                echo "  brew install unzip"
                ;;
            "windows")
                echo "请安装 unzip 工具，或使用 Git Bash/Cygwin/MSYS2"
                ;;
        esac
        exit 1
    fi

    # 检查 find 命令
    if ! command -v find &> /dev/null; then
        echo "错误: 未找到 find 命令"
        exit 1
    fi
}

# 显示使用方法
show_usage() {
    echo "使用方法: ./batch_unzip.sh -o output 目录1 目录2"
    echo "  $0 [-o 输出目录] <输入目录> [输入目录 ...]"
    echo ""
    echo "参数:"
    echo "  -o 输出目录    指定解压文件的输出目录（可选）"
    echo "  输入目录      要处理的目录路径（必选，至少一个）"
    echo ""
    echo "支持的操作系统: Windows(MSYS2/Cygwin/Git Bash), macOS, Linux"
}

# 检查环境和依赖
check_requirements

# 解析命令行参数
output_dir=""
while getopts "o:h" opt; do
    case $opt in
        o)
            output_dir="$OPTARG"
            ;;
        h)
            show_usage
            exit 0
            ;;
        \?)
            show_usage
            exit 1
            ;;
    esac
done

# 移除已处理的参数
shift $((OPTIND-1))

# 检查是否提供了输入目录参数
if [ $# -eq 0 ]; then
    echo "错误: 请提供至少一个输入目录"
    show_usage
    exit 1
fi

# 如果指定了输出目录，确保它存在
if [ -n "$output_dir" ]; then
    if [ ! -d "$output_dir" ]; then
        echo "创建输出目录: $output_dir"
        mkdir -p "$output_dir"
    fi
fi

# 初始化总计数器
total_files=0
total_success=0
total_failed=0

# 处理所有提供的目录
for target_dir in "$@"; do
    # 检查目录是否存在
    if [ ! -d "$target_dir" ]; then
        echo "警告: 目录 '$target_dir' 不存在，跳过"
        continue
    fi
    
    echo "开始处理目录: $target_dir"

    dir_count=0
    success_count=0
    failed_count=0

    # 遍历所有zip文件
    while IFS= read -r zip_file; do
        # 跳过空行
        [ -z "$zip_file" ] && continue
        ((dir_count++))
        echo "正在处理: $zip_file"
        
        # 准备解压目录
        if [ -n "$output_dir" ]; then
            # 如果指定了输出目录，在输出目录中创建子目录
            base_name=$(basename "${zip_file%.zip}")
            # 使用跨平台的路径分隔符
            if [ "$(detect_os)" = "windows" ]; then
                dir_name="$output_dir\\$base_name"
            else
                dir_name="$output_dir/$base_name"
            fi
        else
            # 否则在原地解压
            dir_name="${zip_file%.zip}"
        fi
        mkdir -p "$dir_name"
        
        # 解压文件
        if unzip -q -o "$zip_file" -d "$dir_name"; then
            echo "✅ 成功解压: $zip_file"
            ((success_count++))
        else
            echo "❌ 解压失败: $zip_file"
            ((failed_count++))
        fi
    done < <(find "$target_dir" -type f -name "*.zip")

    # 输出当前目录的统计信息
    echo "----------------------------------------"
    echo "目录 '$target_dir' 处理完成！"
    echo "总文件数: $dir_count"
    echo "成功: $success_count"
    echo "失败: $failed_count"
    echo "----------------------------------------"
    
    # 累计总数
    ((total_files+=dir_count))
    ((total_success+=success_count))
    ((total_failed+=failed_count))
done

# 输出总的统计信息
echo "所有目录处理完成！总统计信息："
echo "总文件数: $total_files"
echo "成功: $total_success"
echo "失败: $total_failed"
