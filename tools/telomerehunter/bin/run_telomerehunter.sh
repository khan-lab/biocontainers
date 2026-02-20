#!/usr/bin/env bash
set -euo pipefail

# Wrapper for TelomereHunter inside the container.
# Accepts TelomereHunter arguments and forwards them.
#
# Usage: run_telomerehunter.sh [args...]
#
# Examples:
#   run_telomerehunter.sh -ibt tumor.bam -ibc control.bam -o /out -p sample1
#   run_telomerehunter.sh -ibt tumor.bam -o /out -p sample1

if [[ $# -eq 0 ]]; then
    echo "Usage: run_telomerehunter.sh [args...]"
    echo ""
    echo "TelomereHunter – telomere content estimation from WGS data"
    echo ""
    echo "Required arguments:"
    echo "  -ibt FILE   Indexed tumor BAM file"
    echo "  -o DIR      Output directory"
    echo "  -p NAME     Sample name for output files"
    echo ""
    echo "Optional arguments:"
    echo "  -ibc FILE   Indexed control BAM file"
    echo "  -pl         Run steps in parallel"
    echo "  -d          Remove duplicate reads"
    echo ""
    echo "See: https://github.com/linasieverling/TelomereHunter"
    exit 0
fi

exec telomerehunter "$@"
