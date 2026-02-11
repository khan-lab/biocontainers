FROM ubuntu:22.04

LABEL org.opencontainers.image.title="deeptools" \
      org.opencontainers.image.description="deepTools – tools for exploring deep-sequencing data" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="BSD-3-Clause"

ARG DEEPTOOLS_VERSION=3.5.6
ARG DEBIAN_FRONTEND=noninteractive

# ---- System dependencies ---------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        && \
    rm -rf /var/lib/apt/lists/*

# ---- Install deepTools ------------------------------------------------------
RUN pip3 install --no-cache-dir deeptools==${DEEPTOOLS_VERSION}

# ---- Wrapper script ----------------------------------------------------------
COPY bin/run_deeptools.sh /usr/local/bin/run_deeptools.sh
RUN chmod +x /usr/local/bin/run_deeptools.sh

# ---- Non-root user ----------------------------------------------------------
RUN groupadd -r biouser && useradd -r -g biouser -m -s /bin/bash biouser
USER biouser

WORKDIR /data

ENTRYPOINT ["deeptools"]
CMD ["--help"]
