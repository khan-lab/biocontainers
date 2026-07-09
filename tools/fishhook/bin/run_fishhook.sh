#!/usr/bin/env bash
set -euo pipefail

# Wrapper for fishHook inside the container.
#
# fishHook is an R package (loaded with library(fishHook)); it has no CLI. Supply
# your mutation events, target intervals, eligible territory and covariate tracks
# from your own analysis (see upstream tutorial data at mskilab.com).
#
# Run an analysis script:
#   docker run --rm -v "$PWD:/data" ghcr.io/khan-lab/fishhook /data/analysis.R
# Or run inline R:
#   docker run --rm ghcr.io/khan-lab/fishhook -e 'library(fishHook); ...'
#
# See: https://github.com/mskilab-org/fishHook

PKG=fishHook

if [[ $# -eq 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "${PKG} is an R package. Provide an R script or use 'Rscript -e' style args."
    echo "See the header of this script or the README for usage."
    Rscript -e "cat('${PKG} version:', as.character(packageVersion('${PKG}')), '\n')" || true
    exit 0
fi

exec Rscript "$@"
