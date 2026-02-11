#!/usr/bin/env bash
set -euo pipefail

# Wrapper for FastQC inside the container.
# Usage: run_fastqc.sh <input_fastq> [output_dir] [extra args...]
#
# If output_dir is provided, it is created and passed as --outdir.
# All remaining arguments are forwarded to fastqc.

INPUT="${1:?Usage: run_fastqc.sh <input_fastq> [output_dir] [extra args...]}"
shift

OUTDIR="${1:-/out}"
shift 2>/dev/null || true

mkdir -p "$OUTDIR"

exec fastqc "$INPUT" --outdir "$OUTDIR" "$@"
