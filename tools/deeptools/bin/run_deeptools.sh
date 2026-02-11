#!/usr/bin/env bash
set -euo pipefail

# Wrapper for deepTools inside the container.
# Runs a deepTools subcommand with all arguments forwarded.
#
# Usage: run_deeptools.sh <subcommand> [args...]
#
# Examples:
#   run_deeptools.sh bamCoverage -b sample.bam -o coverage.bw
#   run_deeptools.sh computeMatrix reference-point -S signal.bw -R genes.bed -o matrix.gz

SUBCMD="${1:?Usage: run_deeptools.sh <subcommand> [args...]}"
shift

exec "$SUBCMD" "$@"
