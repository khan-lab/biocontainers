# DriverPower is only distributed as a conda package on the author's personal
# channel (smshuai), built for linux-64/osx-64 with a pinned 2018-era scientific
# stack. This image is therefore amd64-only (see the platform exception).
FROM mambaorg/micromamba:1.5.8

ARG DRIVERPOWER_VERSION=1.0.2

LABEL org.opencontainers.image.title="driverpower" \
      org.opencontainers.image.description="DriverPower – coding and noncoding cancer driver detection via functional impact and mutational burden" \
      org.opencontainers.image.version="${DRIVERPOWER_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

USER root

RUN micromamba install -y -n base \
        -c smshuai -c bioconda -c conda-forge \
        "driverpower=${DRIVERPOWER_VERSION}" && \
    micromamba clean -a -y

ENV PATH="/opt/conda/bin:${PATH}"

COPY bin/run_driverpower.sh /usr/local/bin/run_driverpower.sh
RUN chmod +x /usr/local/bin/run_driverpower.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_driverpower.sh"]
CMD ["--help"]
