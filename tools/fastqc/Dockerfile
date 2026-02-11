FROM ubuntu:22.04

LABEL org.opencontainers.image.title="fastqc" \
      org.opencontainers.image.description="FastQC – quality control for sequencing data" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-2.0-or-later"

ARG FASTQC_VERSION=0.12.1
# TODO: pin checksum once verified
# ARG FASTQC_SHA256=...

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        default-jre-headless \
        perl \
        wget \
        unzip \
        libfindbin-libs-perl && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip" \
        -O /tmp/fastqc.zip && \
    unzip /tmp/fastqc.zip -d /opt && \
    chmod +x /opt/FastQC/fastqc && \
    ln -s /opt/FastQC/fastqc /usr/local/bin/fastqc && \
    rm /tmp/fastqc.zip

# Copy wrapper script
COPY bin/run_fastqc.sh /usr/local/bin/run_fastqc.sh
RUN chmod +x /usr/local/bin/run_fastqc.sh

# Non-root user
RUN groupadd -r biouser && useradd -r -g biouser -m -s /bin/bash biouser
USER biouser

WORKDIR /data

ENTRYPOINT ["fastqc"]
CMD ["--help"]
