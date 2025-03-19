### Base stage
FROM python:3.12-slim AS base-stage

ENV FLASK_APP=app.py

RUN groupadd -g 101 appgroup && \
    useradd -u 1026 -g 101 -d /app -m appuser && \
    mkdir -p /app/api/uploads && \
    chown -R 1026:101 /app

USER appuser
WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt --user

### Build stage
FROM base-stage AS build-stage

USER root

COPY api ./api

RUN chown -R 1026:101 /app/api/uploads

USER appuser
