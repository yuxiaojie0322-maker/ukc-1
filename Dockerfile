FROM alpine AS builder

ARG SING_BOX_VERSION=1.14.0-rc.1

RUN wget https://github.com/SagerNet/sing-box/releases/download/v${SING_BOX_VERSION}/sing-box-${SING_BOX_VERSION}-linux-amd64.tar.gz && \
    tar -xf sing-box-${SING_BOX_VERSION}-linux-amd64.tar.gz && \
    mv sing-box-${SING_BOX_VERSION}-linux-amd64/sing-box /app

############################################################

FROM debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

COPY templates/config.json /config.json
COPY --from=builder /app /app

EXPOSE 8080

CMD ["/app", "run", "-c", "/config.json"]
