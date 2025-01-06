# 开发文档

## 项目初始化过程

### 1. 环境准备
```bash
# 安装基础工具
sudo apt-get update
sudo apt-get install -y python3-pip python3.12-venv

# 创建并激活Python虚拟环境
python3 -m venv venv
source venv/bin/activate
```

### 2. 项目结构创建
```bash
# 创建必要的目录
mkdir -p src dist

# 创建主要文件
touch README.md
touch requirements.txt
touch Dockerfile
touch .dockerignore
touch src/main.py
touch build_image.sh
```

### 3. 依赖配置
requirements.txt 内容：
```
fastapi==0.104.1
uvicorn==0.24.0
pydantic==2.5.2
```

### 4. 主程序开发
src/main.py 内容：
```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Python Web API Demo")

class Message(BaseModel):
    content: str

@app.get("/")
async def root():
    return {"message": "Welcome to Python Web API Demo"}

@app.post("/echo")
async def echo(message: Message):
    return {"echo": message.content}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

### 5. Docker配置
Dockerfile 内容：
```dockerfile
FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/

EXPOSE 8000

CMD ["python", "src/main.py"]
```

.dockerignore 内容：
```
.git
.gitignore
.vscode
__pycache__
*.pyc
dist/
README.md
LICENSE
```

### 6. 镜像构建脚本
build_image.sh 内容：
```bash
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
```

### 7. 版本控制
```bash
# 初始化git（如果尚未初始化）
git init

# 添加文件到版本控制
git add .
git commit -m "[2024-01-03]: [0.1.0] 初始化项目，创建基础Web API框架"

# 推送到远程仓库（假设已配置）
git push origin main
```

## 本地开发流程

### 1. 运行应用
```bash
# 激活虚拟环境
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 运行应用
python src/main.py
```

### 2. 构建Docker镜像
```bash
# 方法1：直接使用Docker命令
docker build -t python-api-demo:0.1.0 .
docker run -p 8000:8000 python-api-demo:0.1.0

# 方法2：使用构建脚本
chmod +x build_image.sh
./build_image.sh
```

## 版本管理规范

1. 版本号格式：x.x.x
2. 提交信息格式：[{日期}]: [{版本号}] 任务内容简述
3. Docker镜像命名：{项目名}-{时间戳}.tar
4. 保留最新的3个镜像文件

## 目录结构
```
.
├── .dockerignore        # Docker构建忽略文件
├── .git                 # Git版本控制目录
├── .gitignore          # Git忽略文件
├── Dockerfile          # Docker构建文件
├── README.md           # 项目说明文档
├── DEVELOPMENT.md      # 开发文档
├── build_image.sh      # 镜像构建脚本
├── dist/               # 物料存放目录
├── requirements.txt    # Python依赖文件
├── src/               # 源代码目录
│   └── main.py       # 主程序入口
└── venv/              # Python虚拟环境
``` 