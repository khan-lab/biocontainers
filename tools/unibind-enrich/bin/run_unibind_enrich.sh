#!/usr/bin/env bash
# run_unibind_enrich.sh — thin wrapper around UniBind_enrich.sh
#
# Usage:
#   run_unibind_enrich.sh oneSetBg  <LOLA_db> <regions.bed> <background.bed> <out_dir>
#   run_unibind_enrich.sh twoSets   <LOLA_db> <regions1.bed> <regions2.bed>  <out_dir>
#   run_unibind_enrich.sh oneSetNoBg <LOLA_db> <universe.bed> <regions.bed>  <out_dir>
#
# Mount the UniBind LOLA database at /data/lola, e.g.:
#   docker run --rm \
#     -v /path/to/lola_db:/data/lola:ro \
#     -v /path/to/beds:/data:ro \
#     -v /path/to/results:/out \
#     ghcr.io/khan-lab/unibind-enrich:latest \
#     run_unibind_enrich.sh oneSetBg /data/lola /data/regions.bed /data/bg.bed /out
set -euo pipefail
exec UniBind_enrich.sh "$@"
