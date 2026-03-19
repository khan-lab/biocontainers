#!/usr/bin/env bash
# run_shallowhrd.sh — wrapper for shallowHRD HRD scoring scripts
#
# Usage:
#   run_shallowhrd.sh <genome> <ratio_file> <output_dir> [cytoband_file]
#
# Arguments:
#   genome       hg19 or hg38
#   ratio_file   Tab-delimited ratio file from ControlFREEC or QDNAseq
#                Columns: Chromosome  Start  Ratio  RatioMedian
#   output_dir   Directory for output files (mounted at /out)
#   cytoband_file  Optional: path to cytoBand CSV; defaults to bundled file
#
# Example:
#   docker run --rm \
#     -v /path/to/data:/data:ro \
#     -v /path/to/results:/out \
#     ghcr.io/khan-lab/shallowhrd:latest \
#     run_shallowhrd.sh hg38 /data/sample_ratio.txt /out
#
# Reference cytoband files are bundled at:
#   /opt/shallowhrd/cytoBand_adapted_hg19.csv
#   /opt/shallowhrd/cytoBand_adapted_hg38.csv
set -euo pipefail

SCRIPT_DIR="/opt/shallowhrd"

usage() {
    cat <<EOF
Usage: run_shallowhrd.sh <genome> <ratio_file> <output_dir> [cytoband_file]

  genome        hg19 or hg38
  ratio_file    ControlFREEC/QDNAseq ratio file (tab-delimited)
  output_dir    Output directory for HRD results
  cytoband_file Optional: custom cytoBand CSV (bundled files used by default)

Bundled cytoband files:
  hg19: ${SCRIPT_DIR}/cytoBand_adapted_hg19.csv
  hg38: ${SCRIPT_DIR}/cytoBand_adapted_hg38.csv
EOF
    exit 1
}

if [[ $# -lt 3 ]]; then
    usage
fi

GENOME="${1}"
RATIO_FILE="${2}"
OUTPUT_DIR="${3}"
CYTOBAND="${4:-}"

case "${GENOME}" in
    hg19) SCRIPT="${SCRIPT_DIR}/shallowHRD_hg19.R"
          DEFAULT_CYTOBAND="${SCRIPT_DIR}/cytoBand_adapted_hg19.csv" ;;
    hg38) SCRIPT="${SCRIPT_DIR}/shallowHRD_hg38.R"
          DEFAULT_CYTOBAND="${SCRIPT_DIR}/cytoBand_adapted_hg38.csv" ;;
    *)    echo "Error: genome must be hg19 or hg38" >&2; exit 1 ;;
esac

CYTOBAND="${CYTOBAND:-${DEFAULT_CYTOBAND}}"

exec Rscript "${SCRIPT}" "${RATIO_FILE}" "${OUTPUT_DIR}" "${CYTOBAND}"
