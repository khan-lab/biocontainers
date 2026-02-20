#!/usr/bin/env bash
set -euo pipefail

# Wrapper for TelSeq inside the container.
# Accepts TelSeq arguments and forwards them.
#
# Usage: run_telseq.sh [args...]
#
# Examples:
#   run_telseq.sh sample.bam
#   run_telseq.sh -f bamlist.txt
#   run_telseq.sh -o output.txt sample1.bam sample2.bam

if [[ $# -eq 0 ]]; then
    echo "Usage: run_telseq.sh [args...]"
    echo ""
    echo "TelSeq – telomere length estimation from WGS data"
    echo ""
    echo "Arguments:"
    echo "  FILE.bam         One or more BAM files"
    echo "  -f FILE          File listing BAM paths (one per line)"
    echo "  -o FILE          Output file (default: stdout)"
    echo "  -m               Merge results by read group"
    echo "  -H               Suppress header in output"
    echo "  -h               Print header only"
    echo ""
    echo "See: https://github.com/zd1/telseq"
    exit 0
fi

exec telseq "$@"
