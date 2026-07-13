FROM bioconductor/bioconductor_docker:RELEASE_3_21

# fishHook has no released version/tag; built from upstream master (mskilab-org).
ARG FISHHOOK_VERSION=git-master

LABEL org.opencontainers.image.title="fishhook" \
      org.opencontainers.image.description="fishHook – enrichment of somatic mutations in genomic intervals for driver discovery" \
      org.opencontainers.image.version="${FISHHOOK_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-2.0-or-later"

# Bioconductor deps first, then the two GitHub-only packages (gUtils, then fishHook).
RUN Rscript -e ' \
    BiocManager::install(c( \
        "GenomicRanges", \
        "S4Vectors", \
        "IRanges", \
        "GenomeInfoDb", \
        "BiocGenerics", \
        "rtracklayer" \
    ), ask = FALSE, update = FALSE); \
    install.packages("remotes", repos = "https://cloud.r-project.org"); \
    remotes::install_github("mskilab-org/gUtils", upgrade = "never"); \
    remotes::install_github("mskilab-org/fishHook", upgrade = "never"); \
    '

COPY bin/run_fishhook.sh /usr/local/bin/run_fishhook.sh
RUN chmod +x /usr/local/bin/run_fishhook.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_fishhook.sh"]
CMD ["--help"]
