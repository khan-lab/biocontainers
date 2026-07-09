# Dig / DIGDriver is only distributed as a conda package on the author's personal
# channel (mutation_density), built for linux-64/osx-64 with a pinned Python 3.7 /
# R 3.5 / Bioconductor stack. This image is amd64-only (see the platform exception).
#
# DRAFT: this is the highest-risk recipe in the batch (legacy pins + a personal
# channel + an R devtools install of dndscv). Expect to iterate against CI logs.
FROM mambaorg/micromamba:1.5.8

ARG DIGDRIVER_VERSION=0.1

LABEL org.opencontainers.image.title="digdriver" \
      org.opencontainers.image.description="Dig / DIGDriver – deep learning mutation-rate model for coding and noncoding cancer driver detection" \
      org.opencontainers.image.version="${DIGDRIVER_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="BSD-3-Clause"

USER root

RUN micromamba install -y -n base \
        -c mutation_density -c bioconda -c conda-forge \
        "digdriver=${DIGDRIVER_VERSION}" && \
    micromamba clean -a -y

ENV PATH="/opt/conda/bin:${PATH}"

# dndscv (R) is used for the coding mutation-annotation step. Best-effort: if it
# fails to build against the pinned R 3.5, the image still builds — install it in a
# derived image if you need the dNdScv annotation path.
RUN Rscript -e "install.packages('devtools', repos='https://packagemanager.posit.co/cran/__linux__/focal/2020-12-31'); devtools::install_github('im3sanger/dndscv', upgrade='never')" \
    || echo "WARNING: dndscv install skipped (install it in a derived image if required)"

COPY bin/run_digdriver.sh /usr/local/bin/run_digdriver.sh
RUN chmod +x /usr/local/bin/run_digdriver.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_digdriver.sh"]
CMD ["--help"]
