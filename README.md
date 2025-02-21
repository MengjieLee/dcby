# Python Web API Demo

## 项目说明
这是一个基于Python的Web API演示项目，提供基础的HTTP接口服务。

## 环境要求
- Python 3.12
- Docker

## 快速开始
1. 本地运行
```bash
python3.12 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python src/main.py
```

2. Docker运行
```bash
# 使用阿里云官方Python镜像构建
docker build -t python-api-demo .
docker run -p 9527:9527 python-api-demo
```

> 注意：项目使用阿里云官方认证的 Python 镜像以提高在中国大陆的访问速度。如果在海外使用，可以修改 Dockerfile 中的基础镜像为 `python:3.12`。

## 更新日志
- [2024-01-03]: [0.1.0] 初始化项目，创建基础Web API框架
- [2024-01-03]: [0.1.1] 统一Python版本为3.11
- [2024-01-03]: [0.1.2] 添加远程部署功能
- [2025-01-06]: [0.1.3] 增强Dockerfile配置，使用entrypoint.sh作为容器入口点
- [2025-01-08]: [0.1.4] 升级Python版本至3.12
