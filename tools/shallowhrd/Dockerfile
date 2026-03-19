FROM debian:bookworm-slim

ARG SHALLOWHRD_VERSION=git-main
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="shallowhrd" \
      org.opencontainers.image.description="shallowHRD – homologous recombination deficiency detection from shallow WGS" \
      org.opencontainers.image.version="${SHALLOWHRD_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="CC-BY-4.0"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        r-base \
        r-base-dev \
        git \
        ca-certificates \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libfontconfig1-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libfreetype6-dev \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev \
        libcairo2-dev \
        libxt-dev && \
    rm -rf /var/lib/apt/lists/*

# BiocManager → GenomicRanges; CRAN deps + remotes
RUN Rscript -e "\
    install.packages('BiocManager', repos='https://cloud.r-project.org'); \
    BiocManager::install('GenomicRanges', ask=FALSE, update=FALSE); \
    install.packages( \
        c('ggpubr', 'gridExtra', 'DescTools', 'ks', 'ggrepel', 'remotes'), \
        repos='https://cloud.r-project.org')"

# Clone shallowHRD scripts and cytoband reference files
RUN git clone https://github.com/aeeckhou/shallowHRD.git /opt/shallowhrd && \
    chmod +x /opt/shallowhrd/*.R 2>/dev/null || true

COPY bin/run_shallowhrd.sh /usr/local/bin/run_shallowhrd.sh
RUN chmod +x /usr/local/bin/run_shallowhrd.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

# No-arg invocation prints usage and exits 1 — accepted by smoke test
CMD ["bash", "/usr/local/bin/run_shallowhrd.sh"]
