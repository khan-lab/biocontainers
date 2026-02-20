#!/usr/bin/env bash
set -euo pipefail

# Wrapper for MEME Suite inside the container.
# Accepts a MEME Suite command + arguments and forwards them.
#
# Usage: run_meme.sh <command> [args...]
#
# Examples:
#   run_meme.sh meme /data/sequences.fa -dna -o /out/meme_results
#   run_meme.sh fimo /db/JASPAR.meme /data/sequences.fa
#   run_meme.sh tomtom query.meme /db/HOCOMOCO.meme

if [[ $# -eq 0 ]]; then
    echo "Usage: run_meme.sh <command> [args...]"
    echo ""
    echo "MEME Suite – motif-based sequence analysis tools"
    echo ""
    echo "Available commands:"
    echo "  meme            - De novo motif discovery"
    echo "  streme          - Discover enriched motifs in large datasets"
    echo "  fimo            - Scan sequences for motif occurrences"
    echo "  tomtom          - Compare motifs to known databases"
    echo "  ame             - Motif enrichment analysis"
    echo "  sea             - Simple enrichment analysis"
    echo "  meme-chip       - Comprehensive ChIP-seq motif analysis"
    echo "  centrimo        - Local motif enrichment analysis"
    echo "  xstreme         - Comprehensive motif analysis"
    echo ""
    echo "Mount motif databases at /db and reference them in commands."
    echo "See: https://meme-suite.org/meme/"
    exit 0
fi

exec "$@"
