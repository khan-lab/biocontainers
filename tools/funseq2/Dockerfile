# FunSeq2 is a Perl pipeline with compiled C/C++ helpers, installed from source
# with its runtime tools from bioconda. Its bioconda deps (bedtools, tabix,
# ucsc-bigwigaverageoverbed) have linux-aarch64 builds, so this is left multi-arch.
#
# DRAFT: FunSeq2 has hardcoded paths in config.txt / funseq2.sh and builds helpers
# (TFMpvalue, optionally VAT) from source. Expect to iterate against CI logs.
FROM mambaorg/micromamba:1.5.8

# FunSeq2 has no release tag; built from upstream master (gersteinlab).
ARG FUNSEQ2_VERSION=git-master

LABEL org.opencontainers.image.title="funseq2" \
      org.opencontainers.image.description="FunSeq2 – functional annotation and prioritisation of noncoding somatic variants" \
      org.opencontainers.image.version="${FUNSEQ2_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="CC0-1.0"

USER root

# Runtime tools + a C/C++ toolchain to build the bundled helpers.
RUN micromamba install -y -n base \
        -c bioconda -c conda-forge \
        perl perl-parallel-forkmanager \
        bedtools htslib tabix ucsc-bigwigaverageoverbed \
        gcc gxx make git ca-certificates && \
    micromamba clean -a -y

ENV PATH="/opt/conda/bin:${PATH}"

RUN git clone --depth 1 https://github.com/gersteinlab/FunSeq2.git /opt/funseq2

# Build any bundled C/C++ helpers (TFMpvalue etc.) if a build system is present.
RUN cd /opt/funseq2 && { make 2>/dev/null || make -C code 2>/dev/null || \
    echo "WARNING: no top-level make target; build compiled helpers per upstream docs if needed"; }

ENV PATH="/opt/funseq2:${PATH}"

COPY bin/run_funseq2.sh /usr/local/bin/run_funseq2.sh
RUN chmod +x /usr/local/bin/run_funseq2.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_funseq2.sh"]
CMD ["--help"]
