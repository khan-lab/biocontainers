FROM python:3.12-slim

LABEL org.opencontainers.image.title="pyjaspar" \
      org.opencontainers.image.description="pyJASPAR – Python interface to JASPAR motif database" \
      org.opencontainers.image.source="https://github.com/khan-lab/biocontainers" \
      org.opencontainers.image.licenses="MIT"

ARG PYJASPAR_VERSION=4.0.0
ARG DEBIAN_FRONTEND=noninteractive

RUN pip install --no-cache-dir pyjaspar==${PYJASPAR_VERSION}

# Copy wrapper script
COPY bin/run_pyjaspar.sh /usr/local/bin/run_pyjaspar.sh
RUN chmod +x /usr/local/bin/run_pyjaspar.sh

# Non-root user
RUN groupadd -r biouser && useradd -r -g biouser -m -s /bin/bash biouser
USER biouser

WORKDIR /data

ENTRYPOINT ["python3"]
CMD ["--help"]
