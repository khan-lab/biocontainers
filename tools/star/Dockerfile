# ---------- Build stage: compile STAR from source ----------------------------
FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG STAR_VERSION=2.7.11b

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        make \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libncurses-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libdeflate-dev \
        xxd \
        wget \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q \
        https://github.com/alexdobin/STAR/archive/refs/tags/${STAR_VERSION}.tar.gz \
        -O /tmp/STAR.tar.gz && \
    tar xzf /tmp/STAR.tar.gz -C /tmp && \
    rm /tmp/STAR.tar.gz && \
    cd /tmp/STAR-${STAR_VERSION}/source && \
    SIMD="$([ "$(uname -m)" = "x86_64" ] && echo "-mavx2" || echo "")" && \
    make -j$(nproc) STAR CXXFLAGS_SIMD="$SIMD" && \
    cp STAR /usr/local/bin/STAR

# ---------- Runtime stage -----------------------------------------------------
FROM debian:bookworm-slim

ARG STAR_VERSION=2.7.11b

LABEL org.opencontainers.image.title="star" \
      org.opencontainers.image.description="STAR – Spliced Transcripts Alignment to a Reference (RNA-seq)" \
      org.opencontainers.image.version="${STAR_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="MIT"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        zlib1g \
        libbz2-1.0 \
        liblzma5 \
        libncurses6 \
        libcurl4 \
        libssl3 \
        libdeflate0 \
        libgomp1 \
        samtools \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/STAR /usr/local/bin/STAR

COPY bin/run_star.sh /usr/local/bin/run_star.sh
RUN chmod +x /usr/local/bin/run_star.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out /genome && chown -R biouser:biouser /data /out /genome
USER biouser

WORKDIR /data

CMD ["run_star.sh", ""]
