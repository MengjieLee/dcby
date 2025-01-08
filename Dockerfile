# 使用阿里云Linux 3的Python镜像
FROM alibaba-cloud-linux-3-registry.cn-hangzhou.cr.aliyuncs.com/alinux3/python:3.11.1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 9527

ENTRYPOINT ["/app/entrypoint.sh"]