# ---------- Build stage: compile BWA from source ------------------------------
FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG BWA_VERSION=0.7.19

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        make \
        zlib1g-dev \
        wget \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q \
        https://github.com/lh3/bwa/archive/refs/tags/v${BWA_VERSION}.tar.gz \
        -O /tmp/bwa.tar.gz && \
    tar xzf /tmp/bwa.tar.gz -C /tmp && \
    rm /tmp/bwa.tar.gz && \
    cd /tmp/bwa-${BWA_VERSION} && \
    make -j$(nproc) && \
    cp bwa /usr/local/bin/bwa

# ---------- Runtime stage -----------------------------------------------------
FROM debian:bookworm-slim

ARG BWA_VERSION=0.7.19

LABEL org.opencontainers.image.title="bwa" \
      org.opencontainers.image.description="BWA – Burrows-Wheeler Aligner for short-read DNA alignment" \
      org.opencontainers.image.version="${BWA_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        zlib1g \
        samtools \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/bwa /usr/local/bin/bwa

COPY bin/run_bwa.sh /usr/local/bin/run_bwa.sh
RUN chmod +x /usr/local/bin/run_bwa.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

CMD ["bwa"]
