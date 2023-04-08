FROM python:3.9-alpine

WORKDIR /app

COPY hello.txt .

CMD ["python", "-m", "http.server", "8000"]
