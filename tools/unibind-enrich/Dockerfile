FROM debian:bookworm-slim

ARG UNIBIND_VERSION=git-main
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="unibind-enrich" \
      org.opencontainers.image.description="UniBind Enrich – TF binding site enrichment analysis using the UniBind LOLA database" \
      org.opencontainers.image.version="${UNIBIND_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        r-base \
        r-base-dev \
        python3 \
        python3-venv \
        bedtools \
        git \
        wget \
        ca-certificates \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libcairo2-dev \
        libxt-dev \
        libfontconfig1-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libfreetype6-dev \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev \
        libbz2-dev \
        liblzma-dev \
        zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Python visualization dependencies
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"
RUN pip install --no-cache-dir matplotlib numpy pandas seaborn

# R: Bioconductor (LOLA + GenomicRanges stack) + CRAN visualization packages
RUN Rscript -e "\
    if (!requireNamespace('BiocManager', quietly=TRUE)) \
        install.packages('BiocManager', repos='https://cloud.r-project.org'); \
    BiocManager::install( \
        c('LOLA', 'GenomicRanges', 'IRanges', 'S4Vectors', 'BiocGenerics'), \
        ask=FALSE, update=FALSE); \
    install.packages( \
        c('data.table', 'dplyr', 'ggplot2', 'ggbeeswarm', 'plotly', \
          'htmlwidgets', 'RColorBrewer', 'reshape2', 'optparse'), \
        repos='https://cloud.r-project.org')"

# Clone UniBind enrichment scripts
RUN git clone https://bitbucket.org/CBGR/unibind_enrichment.git /opt/unibind && \
    chmod +x /opt/unibind/bin/*.sh /opt/unibind/bin/*.py

ENV PATH="/opt/unibind/bin:${PATH}"

COPY bin/run_unibind_enrich.sh /usr/local/bin/run_unibind_enrich.sh
RUN chmod +x /usr/local/bin/run_unibind_enrich.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out /data/lola && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

# No-arg invocation prints usage and exits 1 — accepted by smoke test
CMD ["UniBind_enrich.sh", "--help"]
