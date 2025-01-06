#!/bin/bash

# 设置变量
REMOTE_HOST="dyejjfnjhrfm.sealoshzh.site"
REMOTE_PORT="9527"
IMAGE_NAME="python-api-demo"
VERSION="0.1.1"

# 获取最新的镜像文件
LATEST_IMAGE=$(ls -t dist/*.tar | head -n1)

if [ -z "$LATEST_IMAGE" ]; then
    echo "错误：未找到镜像文件"
    exit 1
fi

echo "使用镜像文件: $LATEST_IMAGE"

# 加载镜像
echo "正在加载Docker镜像..."
docker load < "$LATEST_IMAGE"

# 停止并删除旧容器（如果存在）
echo "清理旧容器..."
docker rm -f "$IMAGE_NAME" 2>/dev/null || true

# 运行新容器
echo "启动新容器..."
docker run -d \
    --name "$IMAGE_NAME" \
    -p "${REMOTE_PORT}:8000" \
    --restart unless-stopped \
    "${IMAGE_NAME}:${VERSION}"

echo "部署完成！应用已在 http://${REMOTE_HOST}:${REMOTE_PORT} 上运行" 