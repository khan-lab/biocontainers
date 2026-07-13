FROM python:3.11-slim

ARG ONCODRIVEFML_VERSION=2.5.0

LABEL org.opencontainers.image.title="oncodrivefml" \
      org.opencontainers.image.description="OncodriveFML – positive selection in coding and noncoding somatic mutations via functional impact scores" \
      org.opencontainers.image.version="${ONCODRIVEFML_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="AGPL-3.0-or-later"

ARG DEBIAN_FRONTEND=noninteractive

# ---- Build deps for the pytabix C extension (no arm64 wheel) ----------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# ---- Install OncodriveFML from PyPI (pins its own deps, all wheels) ----------
RUN pip install --no-cache-dir oncodrivefml==${ONCODRIVEFML_VERSION}

# ---- Wrapper script ----------------------------------------------------------
COPY bin/run_oncodrivefml.sh /usr/local/bin/run_oncodrivefml.sh
RUN chmod +x /usr/local/bin/run_oncodrivefml.sh

# ---- Non-root user ----------------------------------------------------------
RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_oncodrivefml.sh"]
CMD ["--help"]
