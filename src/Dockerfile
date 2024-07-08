FROM debian:bookworm-slim AS builder
ARG GODOT_VERSION
ARG EXPORT_PLATFORM
COPY install_godot.sh /install_godot.sh
RUN /install_godot.sh



FROM scratch AS temp
COPY --from=builder /usr/local/bin/godot /usr/local/bin/godot
COPY --from=builder /usr/local/share/godot/ /usr/local/share/godot/
COPY --from=builder /usr/bin/brotli /usr/bin/brotli
COPY /install.sh /install.sh



FROM debian:bookworm-slim
LABEL org.opencontainers.image.description="A small Docker image for Godot CI"
ARG DOTNET
COPY --from=temp / /
RUN /install.sh
