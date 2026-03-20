#!/usr/bin/env bash
set -euo pipefail

# Wrapper for WisecondorX inside the container.
# WisecondorX is a three-step workflow:
#   1. convert  – BAM/CRAM → NPZ
#   2. newref   – build a reference from control NPZ files
#   3. predict  – call CNAs in a test sample
#
# Usage: run_wisecondorx.sh <convert|newref|predict|gender> [args...]
#
# Examples:
#   run_wisecondorx.sh convert /data/sample.bam /out/sample.npz
#   run_wisecondorx.sh newref  /data/refs/*.npz /out/reference
#   run_wisecondorx.sh predict /out/sample.npz /out/reference.npz /out/sample

CMD="${1:-}"

if [[ $# -eq 0 ]]; then
    echo "Usage: run_wisecondorx.sh <convert|newref|predict|gender> [args...]"
    echo ""
    echo "WisecondorX – copy number detection from shallow WGS"
    echo ""
    echo "Commands:"
    echo "  convert   Convert BAM/CRAM to NPZ binary format"
    echo "  newref    Build a reference from control NPZ files"
    echo "  predict   Detect copy number alterations in a test sample"
    echo "  gender    Determine sample gender from Y-chromosome fraction"
    echo ""
    echo "Convert args:"
    echo "  infile outfile [--binsize INT] [--rmdup] [-r REF_FASTA]"
    echo ""
    echo "Newref args:"
    echo "  infiles... prefix [--nipt] [--binsize INT] [--cpus INT]"
    echo ""
    echo "Predict args:"
    echo "  infile reference outid [--zscore FLOAT] [--alpha FLOAT]"
    echo "  [--blacklist BED] [--bed] [--plot]"
    echo ""
    echo "See: https://github.com/CenterForMedicalGeneticsGhent/WisecondorX"
    exit 0
fi

exec WisecondorX "$@"
