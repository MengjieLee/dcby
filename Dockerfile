FROM registry.cn-hangzhou.aliyuncs.com/library/python:3.12

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 9527

ENTRYPOINT ["/app/entrypoint.sh"]