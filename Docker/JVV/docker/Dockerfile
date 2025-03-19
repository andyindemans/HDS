### Base stage
FROM python-service-base:latest AS base-stage
WORKDIR /app
COPY --chmod=+x docker/entrypoint*.sh /

COPY api ./api

COPY requirements.txt .

### Build stage
FROM base-stage AS build-stage

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["/entrypoint.sh"]
