#!/usr/bin/env bash
set -euo pipefail

# Wrapper for OncodriveFML inside the container.
#
# OncodriveFML needs a reference genome and functional-impact scores (e.g. CADD)
# that the `bgdata` library downloads on first use into ~/.bgdata. The CADD
# scores are large (~17 GB), so mount a persistent cache directory and point
# BGDATA_LOCAL at it instead of re-downloading into the container each run:
#
#   docker run --rm \
#       -e BGDATA_LOCAL=/data/bgdata \
#       -v /path/to/bgdata_cache:/data/bgdata \
#       -v "$PWD:/data" -v "$PWD/out:/out" \
#       ghcr.io/khan-lab/oncodrivefml \
#       -i /data/mutations.txt -e /data/regions.bed \
#       -t coding -c /data/oncodrivefml_v2.conf -o /out
#
# See: https://github.com/bbglab/oncodrivefml

if [[ $# -eq 0 ]]; then
    echo "Usage: run_oncodrivefml.sh -i MUTATIONS_FILE -e ELEMENTS_FILE -c CONFIG -o OUTDIR [options]"
    echo ""
    echo "OncodriveFML – detects positive selection in coding/noncoding somatic mutations."
    echo ""
    echo "Reference data (genome + CADD scores, ~17 GB) is fetched by bgdata into"
    echo "~/.bgdata on first run. Mount a cache directory and set BGDATA_LOCAL to"
    echo "avoid re-downloading it (see the header of this script or the README)."
    echo ""
    echo "Run 'run_oncodrivefml.sh --help' for the full option list."
    exit 0
fi

exec oncodrivefml "$@"
