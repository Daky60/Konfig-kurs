FROM python:3.9-slim
COPY . /app
WORKDIR /app
ENTRYPOINT [ "python", "program.py" ]