# ---------- Build stage: compile pysam (htslib) and install telomerehunter ---
FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG TELOMEREHUNTER_VERSION=1.1.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-venv \
        python3-pip \
        gcc \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libcurl4-gnutls-dev \
        libssl-dev \
        libdeflate-dev \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"

RUN pip install --no-cache-dir \
        telomerehunter==${TELOMEREHUNTER_VERSION}

# ---------- Runtime stage ----------------------------------------------------
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
        samtools \
        r-base-core \
        zlib1g \
        libbz2-1.0 \
        liblzma5 \
        libcurl4 \
        libssl3 \
        libdeflate0 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:${PATH}"

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

CMD ["telomerehunter", "-h"]
