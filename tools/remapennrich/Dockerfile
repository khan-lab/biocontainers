FROM debian:bookworm-slim

ARG REMAPENNRICH_VERSION=0.99.0
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="remapennrich" \
      org.opencontainers.image.description="ReMapEnrich – genomic region enrichment against the ReMap TF binding catalog" \
      org.opencontainers.image.version="${REMAPENNRICH_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="AGPL-3.0-or-later"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        r-base \
        r-base-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libmariadb-dev \
        libgit2-dev \
        libfontconfig1-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libfreetype6-dev \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev \
        git \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# BiocManager + GenomicRanges
RUN Rscript -e "\
    install.packages('BiocManager', repos='https://cloud.r-project.org'); \
    BiocManager::install('GenomicRanges', ask=FALSE, update=FALSE)"

# CRAN dependencies (split so build failures are easier to diagnose)
RUN Rscript -e "\
    install.packages( \
        c('data.table', 'R.utils', 'optparse'), \
        repos='https://cloud.r-project.org')"

# RMySQL needs MariaDB/MySQL client headers (libmariadb-dev)
RUN Rscript -e "install.packages('RMySQL', repos='https://cloud.r-project.org')"

# remotes is lighter than devtools and sufficient for install_github
RUN Rscript -e "\
    install.packages('remotes', repos='https://cloud.r-project.org'); \
    remotes::install_github('remap-cisreg/ReMapEnrich')"

COPY bin/run_remapennrich.R /usr/local/bin/run_remapennrich.R
RUN chmod +x /usr/local/bin/run_remapennrich.R

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

CMD ["Rscript", "/usr/local/bin/run_remapennrich.R", "--help"]
