# ---------- Runtime stage (single stage: JAR download) -----------------------
FROM debian:bookworm-slim

ARG GRIDSS_VERSION=2.13.2

LABEL org.opencontainers.image.title="gridss" \
      org.opencontainers.image.description="GRIDSS – genome rearrangement identification and structural variant calling" \
      org.opencontainers.image.version="${GRIDSS_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        samtools \
        bwa \
        r-base-core \
        r-base-dev \
        libcurl4-gnutls-dev \
        libssl-dev \
        libxml2-dev \
        wget \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install required R packages for GRIDSS somatic filtering
RUN Rscript -e " \
    install.packages(c('ggplot2', 'argparser', 'R.utils', 'stringdist', 'stringr'), repos='https://cloud.r-project.org'); \
    if (!requireNamespace('BiocManager', quietly=TRUE)) install.packages('BiocManager', repos='https://cloud.r-project.org'); \
    BiocManager::install(c('StructuralVariantAnnotation', 'VariantAnnotation', 'BSgenome'), ask=FALSE)"

# Download GRIDSS JAR
RUN mkdir -p /opt/gridss && \
    wget -q -O /opt/gridss/gridss.jar \
        https://github.com/PapenfussLab/gridss/releases/download/v${GRIDSS_VERSION}/gridss-${GRIDSS_VERSION}-gridss-jar-with-dependencies.jar

ENV GRIDSS_JAR="/opt/gridss/gridss.jar"

COPY bin/run_gridss.sh /usr/local/bin/gridss
RUN chmod +x /usr/local/bin/gridss

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

CMD ["gridss", "--help"]
