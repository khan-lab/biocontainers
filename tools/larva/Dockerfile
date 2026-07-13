# LARVA ships a bundled linux/amd64 `bigWigAverageOverBed` helper that is required
# at build time (dependency-check.sh) and runtime, so this image is amd64-only
# (see the platform exception in build-images.yml).
FROM debian:bookworm-slim

ARG LARVA_VERSION=2.0

LABEL org.opencontainers.image.title="larva" \
      org.opencontainers.image.description="LARVA – large-scale analysis of recurrent variants in noncoding annotations" \
      org.opencontainers.image.version="${LARVA_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="NOASSERTION"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        g++ \
        make \
        bedtools \
        git \
        ca-certificates \
        libssl3 \
        zlib1g && \
    rm -rf /var/lib/apt/lists/*

# Build LARVA from the (untagged) upstream master; produces the `larva` binary.
# We invoke g++ directly (the exact command from the makefile) instead of `make`:
# the makefile's dependency-check.sh insists the runtime data context
# (annotations/replication_timing.bw) be present, but compilation does not need it —
# that data is mounted at runtime, not baked into the image.
RUN git clone --depth 1 https://github.com/gersteinlab/LARVA.git /opt/larva && \
    cd /opt/larva && \
    chmod +x bigWigAverageOverBed && \
    g++ -Wall -o larva larva.cpp p.value.calc.cpp moment.estimator.cpp

ENV PATH="/opt/larva:${PATH}"

COPY bin/run_larva.sh /usr/local/bin/run_larva.sh
RUN chmod +x /usr/local/bin/run_larva.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_larva.sh"]
CMD ["--help"]
