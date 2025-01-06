#!/bin/bash

# 默认配置
DEFAULT_REMOTE_USER="devbox"
DEFAULT_REMOTE_HOST="hzh.sealos.run"
DEFAULT_REMOTE_PORT="38829"
DEFAULT_APP_URL="dyejjfnjhrfm.sealoshzh.site"
DEFAULT_APP_PORT="9527"

# 显示使用帮助
show_usage() {
    echo "用法: $0 [选项]"
    echo "选项:"
    echo "  -h, --host        远程主机地址 (默认: $DEFAULT_REMOTE_HOST)"
    echo "  -p, --port        SSH端口 (默认: $DEFAULT_REMOTE_PORT)"
    echo "  -u, --user        远程用户名 (默认: $DEFAULT_REMOTE_USER)"
    echo "  -a, --app-url     应用访问域名 (默认: $DEFAULT_APP_URL)"
    echo "  -P, --app-port    应用端口 (默认: $DEFAULT_APP_PORT)"
    echo "  --help            显示此帮助信息"
    exit 1
}

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--host)
            REMOTE_HOST="$2"
            shift 2
            ;;
        -p|--port)
            REMOTE_PORT="$2"
            shift 2
            ;;
        -u|--user)
            REMOTE_USER="$2"
            shift 2
            ;;
        -a|--app-url)
            APP_URL="$2"
            shift 2
            ;;
        -P|--app-port)
            APP_PORT="$2"
            shift 2
            ;;
        --help)
            show_usage
            ;;
        *)
            echo "错误: 未知参数 $1"
            show_usage
            ;;
    esac
done

# 使用默认值或命令行参数
REMOTE_USER="${REMOTE_USER:-$DEFAULT_REMOTE_USER}"
REMOTE_HOST="${REMOTE_HOST:-$DEFAULT_REMOTE_HOST}"
REMOTE_PORT="${REMOTE_PORT:-$DEFAULT_REMOTE_PORT}"
APP_URL="${APP_URL:-$DEFAULT_APP_URL}"
APP_PORT="${APP_PORT:-$DEFAULT_APP_PORT}"

# 其他变量设置
REMOTE_PATH="/home/$REMOTE_USER/app"
IMAGE_NAME="python-api-demo"
VERSION="0.1.2"

# 获取最新的镜像文件
LATEST_IMAGE=$(ls -t dist/*.tar | head -n1)
if [ -z "$LATEST_IMAGE" ]; then
    echo "错误：未找到镜像文件"
    exit 1
fi

echo "部署配置信息："
echo "远程主机: $REMOTE_HOST"
echo "SSH端口: $REMOTE_PORT"
echo "远程用户: $REMOTE_USER"
echo "应用地址: $APP_URL"
echo "应用端口: $APP_PORT"
echo "使用镜像文件: $LATEST_IMAGE"

# 创建远程目录
ssh -p $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST "mkdir -p $REMOTE_PATH"

# 复制镜像文件到远程服务器
echo "正在传输镜像文件到远程服务器..."
scp -P $REMOTE_PORT $LATEST_IMAGE $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/image.tar

# 在远程服务器上执行部署
echo "正在远程部署应用..."
ssh -p $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST << EOF
    cd $REMOTE_PATH
    # 加载镜像
    docker load < image.tar
    # 停止并删除旧容器（如果存在）
    docker stop $IMAGE_NAME 2>/dev/null || true
    docker rm $IMAGE_NAME 2>/dev/null || true
    # 启动新容器
    docker run -d --name $IMAGE_NAME -p $APP_PORT:8000 $IMAGE_NAME:$VERSION
    # 检查容器状态
    docker ps | grep $IMAGE_NAME
EOF

echo "部署完成！"
echo "应用可通过以下地址访问："
echo "https://$APP_URL:$APP_PORT" 