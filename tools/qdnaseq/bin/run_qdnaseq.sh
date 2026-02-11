#!/usr/bin/env bash
set -euo pipefail

# Wrapper for QDNAseq R pipeline.
# Forwards all arguments to the R script.
#
# Usage: run_qdnaseq.sh --bam sample.bam --genome hg19 --binSize 15 --outdir /out

exec Rscript /opt/bin/run_qdnaseq.R "$@"
