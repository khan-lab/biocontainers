FROM ubuntu:22.04

LABEL org.opencontainers.image.title="qdnaseq" \
      org.opencontainers.image.description="QDNAseq – shallow WGS CNV calling" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-2.0-or-later"

ARG DEBIAN_FRONTEND=noninteractive

# ---- System dependencies ---------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        r-base \
        r-base-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        pkg-config \
        git \
        wget \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ---- R packages (Bioconductor + helpers) ------------------------------------
RUN Rscript -e ' \
    install.packages("BiocManager", repos = "https://cloud.r-project.org"); \
    BiocManager::install(c( \
        "QDNAseq", \
        "QDNAseq.hg19", \
        "DNAcopy" \
    ), ask = FALSE, update = FALSE); \
    install.packages(c( \
        "optparse", \
        "data.table", \
        "ggplot2" \
    ), repos = "https://cloud.r-project.org"); \
    '

# ---- Copy pipeline scripts --------------------------------------------------
COPY bin/run_qdnaseq.R  /opt/bin/run_qdnaseq.R
COPY bin/run_qdnaseq.sh /opt/bin/run_qdnaseq.sh
RUN chmod +x /opt/bin/run_qdnaseq.sh /opt/bin/run_qdnaseq.R

# ---- Non-root user ----------------------------------------------------------
RUN groupadd -r biouser && useradd -r -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/opt/bin/run_qdnaseq.sh"]
CMD ["--help"]
