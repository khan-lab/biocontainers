FROM bioconductor/bioconductor_docker:RELEASE_3_21

ARG ACTIVEDRIVERWGS_VERSION=1.2.1

LABEL org.opencontainers.image.title="activedriverwgs" \
      org.opencontainers.image.description="ActiveDriverWGS – driver discovery in coding and noncoding cancer genomes" \
      org.opencontainers.image.version="${ACTIVEDRIVERWGS_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

# ActiveDriverWGS is a CRAN package whose hard dependencies are Bioconductor
# packages; install those via BiocManager first, then the CRAN package.
RUN Rscript -e ' \
    BiocManager::install(c( \
        "BSgenome", \
        "Biostrings", \
        "GenomeInfoDb", \
        "GenomicRanges", \
        "IRanges", \
        "S4Vectors" \
    ), ask = FALSE, update = FALSE); \
    install.packages("ActiveDriverWGS", repos = "https://cloud.r-project.org"); \
    '

COPY bin/run_activedriverwgs.sh /usr/local/bin/run_activedriverwgs.sh
RUN chmod +x /usr/local/bin/run_activedriverwgs.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_activedriverwgs.sh"]
CMD ["--help"]
