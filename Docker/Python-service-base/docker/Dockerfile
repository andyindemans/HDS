### Base stage
FROM python:3.12-slim AS base-stage

ENV FLASK_APP=app.py

RUN adduser --disabled-password --home /app --shell /bin/bash app
USER app
WORKDIR /app

COPY requirements.txt ./

RUN echo "export PATH=${PATH}:/app/.local/bin" >> .bashrc

### Build stage
FROM base-stage AS build-stage

COPY api ./api

RUN pip install --no-cache-dir -r requirements.txt --user app
