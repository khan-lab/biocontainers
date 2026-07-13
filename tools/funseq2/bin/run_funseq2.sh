#!/usr/bin/env bash
set -euo pipefail

# Wrapper for FunSeq2 inside the container.
#
# FunSeq2 requires a large external "data context" (~40 GB: conservation, TF
# motifs/binding, enhancer-gene links, precomputed scores) from
# funseq2.gersteinlab.org, mounted at runtime and referenced from config.txt.
# It is NOT baked into this image.
#
# Usage: run_funseq2.sh [funseq2.sh args...]
#   e.g. run_funseq2.sh -f /data/input.vcf -maf 0 -m 1 -inf vcf -outf vcf -nc -o /out
#
# See: https://github.com/gersteinlab/FunSeq2

FUNSEQ=/opt/funseq2/funseq2.sh

if [[ $# -eq 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "FunSeq2 – functional annotation/prioritisation of noncoding somatic variants."
    echo ""
    echo "Requires the ~40 GB FunSeq2 data context (mounted at runtime, referenced from"
    echo "config.txt). See the header of this script or the README."
    echo ""
    echo "Invoking funseq2.sh with no args (prints its own usage):"
    exec bash "${FUNSEQ}"
fi

exec bash "${FUNSEQ}" "$@"
