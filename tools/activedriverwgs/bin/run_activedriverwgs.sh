#!/usr/bin/env bash
set -euo pipefail

# Wrapper for ActiveDriverWGS inside the container.
#
# ActiveDriverWGS is an R package (loaded with library(ActiveDriverWGS)); the main
# entry point is the ActiveDriverWGS() function. Runtime also needs a BSgenome
# package matching your reference (e.g. BSgenome.Hsapiens.UCSC.hg19/hg38, ~700 MB),
# which is not bundled — install it in a derived image or mount an R library.
#
# Run an analysis script:
#   docker run --rm -v "$PWD:/data" ghcr.io/khan-lab/activedriverwgs /data/analysis.R
# Or run inline R:
#   docker run --rm ghcr.io/khan-lab/activedriverwgs -e 'library(ActiveDriverWGS); ...'
#
# See: https://github.com/reimandlab/ActiveDriverWGSR

PKG=ActiveDriverWGS

if [[ $# -eq 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "${PKG} is an R package. Provide an R script or use 'Rscript -e' style args."
    echo "See the header of this script or the README for usage."
    Rscript -e "cat('${PKG} version:', as.character(packageVersion('${PKG}')), '\n')" || true
    exit 0
fi

exec Rscript "$@"
