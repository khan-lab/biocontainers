# ---------- Build stage: compile TelSeq from source ---------------------------
FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        gcc \
        g++ \
        make \
        autoconf \
        automake \
        libtool \
        pkg-config \
        zlib1g-dev \
        libbamtools-dev \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/zd1/telseq.git /tmp/telseq && \
    cd /tmp/telseq/src && \
    ./autogen.sh && \
    ./configure && \
    make && \
    cp Telseq/telseq /usr/local/bin/telseq

# ---------- Runtime stage ----------------------------------------------------
FROM debian:bookworm-slim

ARG TELSEQ_VERSION=0.0.2

LABEL org.opencontainers.image.title="telseq" \
      org.opencontainers.image.description="TelSeq – telomere length estimation from WGS data" \
      org.opencontainers.image.version="${TELSEQ_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libbamtools2.5.0 \
        zlib1g \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/telseq /usr/local/bin/telseq

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

CMD ["telseq"]
