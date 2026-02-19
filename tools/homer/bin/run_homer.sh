#!/usr/bin/env bash
set -euo pipefail

# Wrapper for HOMER inside the container.
# Accepts a HOMER command + arguments and forwards them.
#
# Usage: run_homer.sh <command> [args...]
#
# Examples:
#   run_homer.sh findMotifsGenome.pl peaks.bed hg38 /out -size 200 -mask
#   run_homer.sh annotatePeaks.pl peaks.bed hg38
#   run_homer.sh makeTagDirectory /out/tags sample.bam

if [[ $# -eq 0 ]]; then
    echo "Usage: run_homer.sh <command> [args...]"
    echo ""
    echo "Available HOMER commands:"
    echo "  findMotifsGenome.pl  - Motif discovery in genomic regions"
    echo "  findMotifs.pl        - General motif discovery"
    echo "  annotatePeaks.pl     - Annotate peaks with genomic features"
    echo "  makeTagDirectory     - Create tag directory from alignments"
    echo "  findPeaks            - Call peaks from tag directories"
    echo "  mergePeaks           - Merge overlapping peaks"
    echo ""
    echo "See: http://homer.ucsd.edu/homer/"
    exit 0
fi

exec "$@"
