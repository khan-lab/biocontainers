#!/usr/bin/env bash
set -euo pipefail

# Wrapper for ncdDetect2 inside the container.
#
# ncdDetect2 is an R package (loaded with library(ncdDetect2)); it has no CLI.
# Supply your somatic mutations and per-site/per-sample covariate tracks from your
# own analysis.
#
# Run an analysis script:
#   docker run --rm -v "$PWD:/data" ghcr.io/khan-lab/ncddetect /data/analysis.R
# Or run inline R:
#   docker run --rm ghcr.io/khan-lab/ncddetect -e 'library(ncdDetect2); ...'
#
# See: https://github.com/TobiasMadsen/ncdDetect2

PKG=ncdDetect2

if [[ $# -eq 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "${PKG} is an R package. Provide an R script or use 'Rscript -e' style args."
    echo "See the header of this script or the README for usage."
    Rscript -e "cat('${PKG} version:', as.character(packageVersion('${PKG}')), '\n')" || true
    exit 0
fi

exec Rscript "$@"
