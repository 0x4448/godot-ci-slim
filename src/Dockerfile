FROM debian:bookworm-slim AS builder

ARG GODOT_VERSION
ARG EXPORT_PLATFORM

# hadolint global ignore=DL3008
RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    brotli \
    ca-certificates \
    curl \
    jq \
    unzip \
  && rm -rf /var/lib/apt/lists/*

COPY install.sh /install.sh
RUN /install.sh



FROM scratch AS temp
COPY --from=builder /usr/local/bin/godot /usr/local/bin/godot
COPY --from=builder /usr/local/share/godot/ /usr/local/share/godot/
COPY --from=builder /usr/bin/brotli /usr/bin/brotli



FROM debian:bookworm-slim
LABEL org.opencontainers.image.description="A small Docker image for Godot CI"
COPY --from=temp / /
RUN apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
  && rm -rf /var/lib/apt/lists/*
