FROM python:3.12-slim AS base-stage

ENV FLASK_APP=app.py

RUN groupadd -g 101 appgroup && \
    useradd -u 1026 -g 101 -d /app -m appuser && \
    groupadd -g 102 docker && \
    usermod -aG docker appuser && \
    chown -R 1026:101 /app

USER appuser
WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt --user

### Build stage
FROM base-stage AS build-stage

USER root

COPY api ./api

USER appuser

COPY --chmod=+x docker/entrypoint*.sh /

EXPOSE 5001

ENTRYPOINT ["/entrypoint.sh"]
