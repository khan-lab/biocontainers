#!/usr/bin/env bash
set -euo pipefail

# Wrapper for BWA inside the container.
# Typical workflow:
#   1. bwa index  – index the reference FASTA
#   2. bwa mem    – align reads and output SAM
#
# Usage: run_bwa.sh <index|mem|...> [args...]
#
# Examples:
#   run_bwa.sh index /data/reference.fa
#   run_bwa.sh mem -t 8 -R "@RG\tID:sample\tSM:sample" \
#       /data/reference.fa /data/read1.fq.gz /data/read2.fq.gz \
#       | samtools sort -o /out/aligned.bam

if [[ $# -eq 0 ]]; then
    echo "Usage: run_bwa.sh <index|mem|...> [args...]"
    echo ""
    echo "BWA – Burrows-Wheeler Aligner"
    echo ""
    echo "Commands:"
    echo "  index   Build FM-index for a reference FASTA"
    echo "  mem     Align reads to a reference (recommended for reads ≥70 bp)"
    echo ""
    echo "Common mem args:"
    echo "  -t INT        Number of threads"
    echo "  -R STR        Read group header line (e.g. '@RG\\tID:id\\tSM:sample')"
    echo "  -M            Mark shorter split hits as secondary (for Picard/GATK compat)"
    echo ""
    echo "See: https://github.com/lh3/bwa"
    exit 0
fi

exec bwa "$@"
