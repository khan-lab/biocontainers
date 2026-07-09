# MutEnricher pins a Python 3.7 / 2021-era scientific stack (numpy 1.17.3, scipy
# 1.3.1, pysam 0.15.2). Those versions only ship prebuilt wheels for linux/amd64,
# so this image is amd64-only (see the platform exception in build-images.yml).
FROM python:3.7.7

ARG MUTENRICHER_VERSION=1.3.3

LABEL org.opencontainers.image.title="mutenricher" \
      org.opencontainers.image.description="MutEnricher – somatic coding and noncoding mutation enrichment analysis" \
      org.opencontainers.image.version="${MUTENRICHER_VERSION}" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="MIT"

# ---- Pinned dependencies (match upstream's tested versions) ------------------
RUN pip install --no-cache-dir \
        numpy==1.17.3 \
        scipy==1.3.1 \
        cython==0.29.13 \
        pysam==0.15.2 \
        cyvcf2==0.20.0

# ---- Fetch MutEnricher at the pinned tag and build the Cython extension ------
RUN wget -q "https://github.com/asoltis/MutEnricher/archive/refs/tags/v${MUTENRICHER_VERSION}.tar.gz" \
        -O /tmp/mutenricher.tar.gz && \
    tar xzf /tmp/mutenricher.tar.gz -C /opt && \
    rm /tmp/mutenricher.tar.gz && \
    mv "/opt/MutEnricher-${MUTENRICHER_VERSION}" /opt/MutEnricher && \
    cd /opt/MutEnricher/math_funcs && \
    python setup.py build_ext --inplace

COPY bin/run_mutenricher.sh /usr/local/bin/run_mutenricher.sh
RUN chmod +x /usr/local/bin/run_mutenricher.sh

RUN groupadd -r biouser && useradd -r -u 1001 -g biouser -m -s /bin/bash biouser
RUN mkdir -p /data /out && chown -R biouser:biouser /data /out
USER biouser

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/run_mutenricher.sh"]
CMD ["--help"]
