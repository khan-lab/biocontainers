#!/usr/bin/env bash
set -euo pipefail

# Wrapper for MACS3 inside the container.
# Forwards all arguments to the macs3 CLI.
#
# Usage: run_macs3.sh <subcommand> [args...]
#
# Examples:
#   run_macs3.sh callpeak -t treatment.bam -c control.bam -g hs -n sample --outdir /out
#   run_macs3.sh bdgpeakcall -i treat_pileup.bdg -o peaks.bed

# Create default output directory
mkdir -p /out 2>/dev/null || true

exec macs3 "$@"
