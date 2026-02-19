FROM bioconductor/bioconductor_docker:RELEASE_3_21

ARG RGREAT_VERSION=2.12.2

LABEL org.opencontainers.image.title="rgreat" \
      org.opencontainers.image.description="rGREAT – genomic region enrichment analysis" \
      org.opencontainers.image.version="${RGREAT_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="MIT"

RUN Rscript -e ' \
    BiocManager::install(c( \
        "rGREAT", \
        "GenomicRanges", \
        "rtracklayer", \
        "optparse" \
    ), ask = FALSE, update = FALSE); \
    '

COPY bin/run_rgreat.R  /usr/local/bin/run_rgreat.R
COPY bin/run_rgreat.sh /usr/local/bin/run_rgreat.sh
RUN chmod +x /usr/local/bin/run_rgreat.R /usr/local/bin/run_rgreat.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

CMD ["R", "--help"]
