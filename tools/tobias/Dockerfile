FROM ubuntu:22.04

LABEL org.opencontainers.image.title="tobias" \
      org.opencontainers.image.description="TOBIAS – TF occupancy prediction from ATAC-seq" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="MIT"

ARG TOBIAS_VERSION=0.17.3
ARG DEBIAN_FRONTEND=noninteractive

# ---- System dependencies (includes build deps + external tools) -------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        python3-dev \
        gcc \
        g++ \
        zlib1g-dev \
        liblzma-dev \
        libbz2-dev \
        libcurl4-openssl-dev \
        samtools \
        bedtools \
        wget \
        ca-certificates \
        && \
    rm -rf /var/lib/apt/lists/*

# ---- Install TOBIAS ----------------------------------------------------------
RUN pip3 install --no-cache-dir \
        cython \
        tobias==${TOBIAS_VERSION}

# ---- Wrapper script ----------------------------------------------------------
COPY bin/run_tobias.sh /usr/local/bin/run_tobias.sh
RUN chmod +x /usr/local/bin/run_tobias.sh

# ---- Non-root user ----------------------------------------------------------
RUN groupadd -r biouser && useradd -r -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["TOBIAS"]
CMD ["--help"]
