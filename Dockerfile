FROM python:3.9-alpine

RUN apk update
RUN apk add openssh

WORKDIR /app

COPY hello.txt .

CMD ["python", "-m", "http.server", "8000"]
