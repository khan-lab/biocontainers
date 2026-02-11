FROM ubuntu:22.04

LABEL org.opencontainers.image.title="macs3" \
      org.opencontainers.image.description="MACS3 – Model-based Analysis of ChIP-Seq" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="BSD-3-Clause"

ARG MACS3_VERSION=3.0.3
ARG DEBIAN_FRONTEND=noninteractive

# ---- System dependencies (includes build deps for C extensions) -------------
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
        && \
    rm -rf /var/lib/apt/lists/*

# ---- Install MACS3 ----------------------------------------------------------
RUN pip3 install --no-cache-dir macs3==${MACS3_VERSION}

# ---- Wrapper script ----------------------------------------------------------
COPY bin/run_macs3.sh /usr/local/bin/run_macs3.sh
RUN chmod +x /usr/local/bin/run_macs3.sh

# ---- Non-root user ----------------------------------------------------------
RUN groupadd -r biouser && useradd -r -g biouser -m -s /bin/bash biouser
RUN mkdir -p /out && chown biouser:biouser /out
USER biouser

WORKDIR /data

ENTRYPOINT ["macs3"]
CMD ["--help"]
