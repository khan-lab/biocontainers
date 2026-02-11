FROM ubuntu:22.04

LABEL org.opencontainers.image.title="rose" \
      org.opencontainers.image.description="ROSE – super-enhancer identification" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="MIT"

ARG DEBIAN_FRONTEND=noninteractive

# TODO: Pin to a specific commit or tag once verified
ARG ROSE_REPO=https://github.com/stjude/ROSE.git
ARG ROSE_REF=master

# ---- System dependencies ---------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-setuptools \
        bedtools \
        samtools \
        r-base-core \
        wget \
        unzip \
        git \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ---- Python dependencies ---------------------------------------------------
RUN pip3 install --no-cache-dir \
        numpy \
        scipy

# ---- Clone ROSE -------------------------------------------------------------
RUN git clone --depth 1 --branch "$ROSE_REF" "$ROSE_REPO" /opt/rose

# ---- Wrapper scripts --------------------------------------------------------
COPY bin/run_rose.sh /usr/local/bin/run_rose.sh
RUN chmod +x /usr/local/bin/run_rose.sh

# Convenience symlink so "rose" invokes the wrapper
RUN ln -s /usr/local/bin/run_rose.sh /usr/local/bin/rose

# ---- Non-root user ----------------------------------------------------------
RUN groupadd -r biouser && useradd -r -g biouser -m -s /bin/bash biouser
RUN mkdir -p /out && chown biouser:biouser /out
USER biouser

WORKDIR /data

ENTRYPOINT ["run_rose.sh"]
CMD ["--help"]
