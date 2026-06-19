# Build stage: install dependencies
FROM registry.access.redhat.com/ubi9/nodejs-22 AS builder

ENV APP_ROOT=/opt/app-root

WORKDIR $APP_ROOT

USER root

COPY src/ .

RUN npm ci --omit=dev

# Runtime stage: hardened minimal image
FROM registry.access.redhat.com/hi/nodejs:22

LABEL org.opencontainers.image.title="qod-web" \
      org.opencontainers.image.description="Quote of the Day frontend" \
      org.opencontainers.image.source="https://github.com/johankok/qod-web"

ENV APP_ROOT=/tmp/app

WORKDIR $APP_ROOT

COPY --from=builder /opt/app-root/node_modules ./node_modules
COPY src/ .

EXPOSE 8080

CMD ["node", "app.js"]
