#!/bin/bash
set -e

# 确保工作目录正确
cd /app

# 设置默认环境变量
export PORT=${PORT:-9527}
export HOST=${HOST:-"0.0.0.0"}
export WORKERS=${WORKERS:-4}

# 如果传入了自定义命令则执行
if [ $# -gt 0 ]; then
    exec "$@"
else
    # 默认启动 FastAPI 服务
    echo "Starting FastAPI server on ${HOST}:${PORT} with ${WORKERS} workers..."
    exec python -m uvicorn src.main:app \
        --host "${HOST}" \
        --port "${PORT}" \
        --workers "${WORKERS}" \
        --proxy-headers \
        --forwarded-allow-ips "*"
fi