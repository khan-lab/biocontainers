#!/usr/bin/env bash
set -euo pipefail

# Wrapper for MutSpot inside the container.
#
# MutSpot is an R package (loaded with library(MutSpot)); it has no CLI. Supply
# your mutation MAF files and epigenomic feature tracks from your own analysis.
# Runtime needs BSgenome.Hsapiens.UCSC.hg19/hg38 (bundled in this image).
#
# Run an analysis script:
#   docker run --rm -v "$PWD:/data" ghcr.io/khan-lab/mutspot /data/analysis.R
# Or run inline R:
#   docker run --rm ghcr.io/khan-lab/mutspot -e 'library(MutSpot); ...'
#
# See: https://github.com/skandlab/MutSpot

PKG=MutSpot

if [[ $# -eq 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "${PKG} is an R package. Provide an R script or use 'Rscript -e' style args."
    echo "See the header of this script or the README for usage."
    Rscript -e "cat('${PKG} version:', as.character(packageVersion('${PKG}')), '\n')" || true
    exit 0
fi

exec Rscript "$@"
