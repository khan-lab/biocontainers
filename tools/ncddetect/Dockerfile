FROM rocker/r-ver:4.4.2

# ncdDetect2 has no released version/tag; built from upstream master (TobiasMadsen).
ARG NCDDETECT_VERSION=git-master

LABEL org.opencontainers.image.title="ncddetect" \
      org.opencontainers.image.description="ncdDetect2 – noncoding cancer driver detection via a probabilistic mutation-rate model" \
      org.opencontainers.image.version="${NCDDETECT_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="NOASSERTION"

ARG DEBIAN_FRONTEND=noninteractive

# System libs for compiling the Rcpp/C++ sources and CRAN deps.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        libxml2-dev \
        libcurl4-openssl-dev \
        libssl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN Rscript -e ' \
    install.packages(c("Rcpp", "VGAM", "data.table", "remotes"), repos = "https://cloud.r-project.org"); \
    remotes::install_github("TobiasMadsen/ncdDetect2", upgrade = "never"); \
    '

COPY bin/run_ncddetect.sh /usr/local/bin/run_ncddetect.sh
RUN chmod +x /usr/local/bin/run_ncddetect.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_ncddetect.sh"]
CMD ["--help"]
