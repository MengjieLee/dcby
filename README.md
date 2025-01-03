# Python Web API Demo

## 项目说明
这是一个基于Python的Web API演示项目，提供基础的HTTP接口服务。

## 环境要求
- Python 3.8+
- Docker

## 快速开始
1. 本地运行
```bash
pip install -r requirements.txt
python src/main.py
```

2. Docker运行
```bash
docker build -t python-api-demo .
docker run -p 8000:8000 python-api-demo
```

## 更新日志
[2024-01-03]: [0.1.0] 初始化项目，创建基础Web API框架
