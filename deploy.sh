#!/bin/bash

# 设置变量
REMOTE_USER="devbox"
REMOTE_HOST="hzh.sealos.run"
REMOTE_PORT="38829"
REMOTE_PATH="/home/devbox/app"
APP_PORT="9527"
IMAGE_NAME="python-api-demo"
VERSION="0.1.2"

# 获取最新的镜像文件
LATEST_IMAGE=$(ls -t dist/*.tar | head -n1)
if [ -z "$LATEST_IMAGE" ]; then
    echo "错误：未找到镜像文件"
    exit 1
fi

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
echo "https://dyejjfnjhrfm.sealoshzh.site:$APP_PORT" 