#!/usr/bin/env bash
set -euo pipefail

# Wrapper for rGREAT enrichment pipeline.
# Forwards all arguments to the R script.
#
# Usage: run_rgreat.sh --bed regions.bed --genome hg38 --outdir /out

exec Rscript /usr/local/bin/run_rgreat.R "$@"
