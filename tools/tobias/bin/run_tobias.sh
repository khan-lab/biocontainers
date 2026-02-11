#!/usr/bin/env bash
set -euo pipefail

# Wrapper for TOBIAS inside the container.
# Forwards all arguments to the TOBIAS CLI.
#
# Usage: run_tobias.sh <subcommand> [args...]
#
# Examples:
#   run_tobias.sh ATACorrect --bam atac.bam --genome genome.fa --peaks peaks.bed --outdir /out
#   run_tobias.sh ScoreBigwig --signal corrected.bw --regions peaks.bed --output footprints.bw
#   run_tobias.sh BINDetect --motifs motifs.jaspar --signals cond1.bw cond2.bw --genome genome.fa --peaks peaks.bed --outdir /out

# Create default output directory
mkdir -p /out 2>/dev/null || true

exec TOBIAS "$@"
