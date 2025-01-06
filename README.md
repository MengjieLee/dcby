# Python Web API Demo

## 项目说明
这是一个基于Python的Web API演示项目，提供基础的HTTP接口服务。

## 环境要求
- Python 3.11
- Docker

## 快速开始
1. 本地运行
```bash
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python src/main.py
```

2. Docker运行
```bash
docker build -t python-api-demo .
docker run -p 9527:8000 python-api-demo
```

## 公网访问
API服务可通过以下地址访问：
- 地址：https://dyejjfnjhrfm.sealoshzh.site
- 端口：9527

## 更新日志
[2024-01-03]: [0.1.0] 初始化项目，创建基础Web API框架
[2024-01-03]: [0.1.1] 统一Python版本为3.11
[2024-01-03]: [0.1.2] 更新公网访问配置，修改服务端口为9527
