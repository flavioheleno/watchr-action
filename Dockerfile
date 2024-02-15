FROM ghcr.io/flavioheleno/watchr:v0.5.2

ARG VERSION=latest

COPY entrypoint.sh /entrypoint.sh

LABEL maintainer="Flavio Heleno <flaviohbatista@gmail.com>" \
      org.opencontainers.image.authors="flaviohbatista@gmail.com" \
      org.opencontainers.image.base.name="ghcr.io/flavioheleno/watchr-action:${VERSION}" \
      org.opencontainers.image.source="https://github.com/flavioheleno/watchr-action" \
      org.opencontainers.image.title="Watchr GHA" \
      org.opencontainers.image.description="Monitor your domain and certificates from GitHub Actions" \
      org.opencontainers.image.url="https://github.com/flavioheleno/watchr-action" \
      org.opencontainers.image.vendor="Flavio Heleno" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.licenses="MIT"

ENTRYPOINT ["/entrypoint.sh"]
