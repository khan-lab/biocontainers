# ---------- Build stage: prebuilt binary (amd64) or compile via Nim (arm64) --
FROM debian:bookworm-slim AS builder

ARG MOSDEPTH_VERSION=0.3.12
ARG TARGETARCH
ARG DEBIAN_FRONTEND=noninteractive

# nim (from apt) is used for the arm64 source compilation path only;
# it adds ~100 MB to the builder stage but is not copied to the runtime image.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        git \
        gcc \
        make \
        nim \
        ca-certificates \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libcurl4-openssl-dev \
        libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# amd64: download the prebuilt static binary from GitHub releases
# arm64: compile from source using system Nim (Debian bookworm nim 1.6.x)
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        wget -q -O /usr/local/bin/mosdepth \
            https://github.com/brentp/mosdepth/releases/download/v${MOSDEPTH_VERSION}/mosdepth && \
        chmod +x /usr/local/bin/mosdepth; \
    else \
        git clone --depth 1 --branch v${MOSDEPTH_VERSION} \
            https://github.com/brentp/mosdepth.git /tmp/mosdepth && \
        cd /tmp/mosdepth && \
        nimble build -y -d:release && \
        cp /tmp/mosdepth/mosdepth /usr/local/bin/mosdepth; \
    fi

# ---------- Runtime stage -----------------------------------------------------
FROM debian:bookworm-slim

ARG MOSDEPTH_VERSION=0.3.12
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="mosdepth" \
      org.opencontainers.image.description="mosdepth – fast BAM/CRAM depth calculation" \
      org.opencontainers.image.version="${MOSDEPTH_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="MIT"

# Runtime libs needed for CRAM support (static binary on amd64 needs none,
# but compiled binary on arm64 may link against system libs)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        libcurl4 \
        libssl3 \
        zlib1g \
        libbz2-1.0 \
        liblzma5 \
        libhts3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/mosdepth /usr/local/bin/mosdepth

COPY bin/run_mosdepth.sh /usr/local/bin/run_mosdepth.sh
RUN chmod +x /usr/local/bin/run_mosdepth.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

CMD ["mosdepth", "--help"]
