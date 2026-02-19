# ---------- Build stage: compile C++ components ------------------------------
FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        perl \
        wget \
        unzip \
        zip \
        gcc \
        g++ \
        make \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/homer && \
    cd /opt/homer && \
    wget -q http://homer.ucsd.edu/homer/configureHomer.pl && \
    perl configureHomer.pl -install

# ---------- Runtime stage ----------------------------------------------------
FROM debian:bookworm-slim

ARG HOMER_VERSION=5.1

LABEL org.opencontainers.image.title="homer" \
      org.opencontainers.image.description="HOMER – motif discovery and ChIP-seq analysis" \
      org.opencontainers.image.version="${HOMER_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        perl \
        samtools \
        r-base-core \
        wget \
        unzip \
        procps \
        zip \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/homer /opt/homer

ENV PATH="/opt/homer/bin:${PATH}"

COPY bin/run_homer.sh /usr/local/bin/run_homer.sh
RUN chmod +x /usr/local/bin/run_homer.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

CMD ["findMotifsGenome.pl"]
