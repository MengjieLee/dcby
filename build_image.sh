#!/bin/bash

# 设置版本号
VERSION="0.1.0"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
IMAGE_NAME="python-api-demo"

# 创建dist目录（如果不存在）
mkdir -p dist

# 构建Docker镜像
echo "正在构建Docker镜像 ${IMAGE_NAME}:${VERSION}..."
docker build -t ${IMAGE_NAME}:${VERSION} .

# 保存镜像到dist目录
echo "正在保存镜像到 dist/${IMAGE_NAME}-${TIMESTAMP}.tar..."
docker save ${IMAGE_NAME}:${VERSION} > dist/${IMAGE_NAME}-${TIMESTAMP}.tar

# 清理旧的镜像文件（保留最新的3个）
echo "清理旧的镜像文件..."
cd dist && ls -t *.tar | tail -n +4 | xargs -r rm --

echo "镜像构建完成！" 