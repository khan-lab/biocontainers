#!/usr/bin/env bash
# run_mosdepth.sh — wrapper for mosdepth depth calculation
#
# Usage:
#   docker run --rm \
#     -v /path/to/bams:/data:ro \
#     -v /path/to/output:/out \
#     ghcr.io/khan-lab/mosdepth:latest \
#     run_mosdepth.sh [options] <prefix> <BAM-or-CRAM>
#
# Examples:
#   # WGS per-base depth
#   run_mosdepth.sh /out/sample /data/sample.bam
#
#   # WGS windowed depth (500 bp windows, skip per-base output)
#   run_mosdepth.sh -n --by 500 /out/sample /data/sample.bam
#
#   # Exome with target regions
#   run_mosdepth.sh --by /data/targets.bed /out/sample /data/sample.bam
#
#   # CRAM input (requires reference FASTA)
#   run_mosdepth.sh -f /data/ref.fa /out/sample /data/sample.cram
set -euo pipefail
exec mosdepth "$@"
