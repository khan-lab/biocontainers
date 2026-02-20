# ---------- Runtime stage -----------------------------------------------------
FROM debian:bookworm-slim

ARG TELOMEREHUNTER_VERSION=1.1.0

LABEL org.opencontainers.image.title="telomerehunter" \
      org.opencontainers.image.description="TelomereHunter – telomere content estimation from WGS data" \
      org.opencontainers.image.version="${TELOMEREHUNTER_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        samtools \
        r-base-core \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir --break-system-packages \
        telomerehunter==${TELOMEREHUNTER_VERSION}

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

CMD ["telomerehunter", "-h"]
