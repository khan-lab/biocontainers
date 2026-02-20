# ---------- Build stage: compile MEME Suite from source -----------------------
FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG MEME_VERSION=5.5.9

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        make \
        perl \
        python3 \
        zlib1g-dev \
        libxml2-dev \
        libxslt1-dev \
        wget \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://meme-suite.org/meme/meme-software/${MEME_VERSION}/meme-${MEME_VERSION}.tar.gz && \
    tar xzf meme-${MEME_VERSION}.tar.gz && \
    cd meme-${MEME_VERSION} && \
    ./configure --prefix=/opt/meme \
        --enable-build-libxml2 \
        --enable-build-libxslt && \
    make -j$(nproc) && \
    make install && \
    rm -rf /meme-${MEME_VERSION} /meme-${MEME_VERSION}.tar.gz

# Download Motif Databases and GOMo Databases (not sequence databases)
RUN mkdir -p /opt/meme/db && \
    wget -q https://meme-suite.org/meme/meme-software/Databases/motifs/motif_databases.12.27.tgz && \
    tar xzf motif_databases.12.27.tgz -C /opt/meme/db/ && \
    rm motif_databases.12.27.tgz && \
    wget -q https://meme-suite.org/meme/meme-software/Databases/gomo/gomo_databases.3.2.tgz && \
    tar xzf gomo_databases.3.2.tgz -C /opt/meme/db/ && \
    rm gomo_databases.3.2.tgz

# ---------- Runtime stage ----------------------------------------------------
FROM debian:bookworm-slim

ARG MEME_VERSION=5.5.9

LABEL org.opencontainers.image.title="meme" \
      org.opencontainers.image.description="MEME Suite – motif-based sequence analysis tools" \
      org.opencontainers.image.version="${MEME_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="SEE meme-suite.org"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        perl \
        python3 \
        zlib1g \
        ghostscript \
        libxml2 \
        libxslt1.1 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/meme /opt/meme

ENV PATH="/opt/meme/bin:/opt/meme/libexec/meme-${MEME_VERSION}:${PATH}"

COPY bin/run_meme.sh /usr/local/bin/run_meme.sh
RUN chmod +x /usr/local/bin/run_meme.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out /db && chown -R biouser:biouser /data /out /db
USER biouser

WORKDIR /data

CMD ["meme", "-version"]
