# DriverPower targets a Python 3.7 / 2018-era scientific stack (scikit-learn
# 0.19.2, xgboost, ...). Those pinned versions only ship linux/amd64 (cp37) wheels,
# so this image is amd64-only (see the platform exception in build-images.yml).
#
# Installed from PyPI rather than the author's personal conda channel: the conda
# build pins scikit-learn 0.19.2 to a python 3.7 build that does not exist on
# bioconda/conda-forge (unsolvable), whereas the exact-version wheels do exist on
# PyPI. Deps are pinned explicitly, then DriverPower is installed with --no-deps.
FROM python:3.7

ARG DRIVERPOWER_VERSION=1.0.2

LABEL org.opencontainers.image.title="driverpower" \
      org.opencontainers.image.description="DriverPower – coding and noncoding cancer driver detection via functional impact and mutational burden" \
      org.opencontainers.image.version="${DRIVERPOWER_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="GPL-3.0-or-later"

ARG DEBIAN_FRONTEND=noninteractive

# bedtools is the runtime dependency behind pybedtools.
RUN apt-get update && \
    apt-get install -y --no-install-recommends bedtools && \
    rm -rf /var/lib/apt/lists/*

# Pinned py37-era scientific stack (all have cp37 wheels), then DriverPower itself.
RUN pip install --no-cache-dir \
        numpy==1.16.6 \
        scipy==1.2.3 \
        pandas==0.24.2 \
        scikit-learn==0.19.2 \
        statsmodels==0.10.2 \
        patsy==0.5.2 \
        xgboost==0.90 \
        tables==3.5.2 \
        pybedtools==0.8.1 && \
    pip install --no-cache-dir --no-deps "DriverPower==${DRIVERPOWER_VERSION}"

COPY bin/run_driverpower.sh /usr/local/bin/run_driverpower.sh
RUN chmod +x /usr/local/bin/run_driverpower.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_driverpower.sh"]
CMD ["--help"]
