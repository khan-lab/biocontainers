#!/usr/bin/env bash
set -euo pipefail

# Wrapper for LARVA inside the container.
#
# LARVA requires its "data context" files to be present under "code/annotations/"
# relative to the working directory (/data):
#   code/annotations/replication_timing.bw
#   code/annotations/blacklist_regions.bed
#   code/annotations/genes.bed
#   code/annotations/pgenes.bed
# These come from larva.gersteinlab.org (~245 MB) and are NOT baked into the image.
#
# Usage: run_larva.sh -vf <variant file> -af <annotation file> -o <output file> [-b]
#
# Example (data context mounted at /data/code/annotations):
#   run_larva.sh -vf /data/mutations.bed -af /data/elements.bed -o /out/results.txt
#
# See: https://github.com/gersteinlab/LARVA  and  http://larva.gersteinlab.org

if [[ $# -eq 0 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    echo "LARVA - recurrent-variant analysis in noncoding annotations."
    echo ""
    echo "Provide the LARVA data context in ./code/annotations/ (replication_timing.bw,"
    echo "blacklist_regions.bed, genes.bed, pgenes.bed); ~245 MB, not bundled."
    echo ""
    larva -h || true
    exit 0
fi

exec larva "$@"
