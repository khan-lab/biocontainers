#!/usr/bin/env bash
set -euo pipefail

# Wrapper for MutEnricher inside the container.
#
# Usage: run_mutenricher.sh <coding|noncoding> [args...]
#
# Examples (using your own inputs mounted at /data, output to /out):
#   run_mutenricher.sh coding    /data/genes.gtf.gz  /data/vcf_files.txt -o /out --prefix run
#   run_mutenricher.sh noncoding /data/regions.bed   /data/vcf_files.txt -o /out --prefix run
#
# See: https://github.com/asoltis/MutEnricher

MUTENRICHER=/opt/MutEnricher/mutEnricher.py

if [[ $# -eq 0 ]]; then
    exec python "${MUTENRICHER}" -h
fi

exec python "${MUTENRICHER}" "$@"
