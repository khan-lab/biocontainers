#!/usr/bin/env bash
set -euo pipefail

# Wrapper for ROSE super-enhancer identification.
# Forwards all arguments to rose2.
#
# Usage: run_rose.sh [ROSE arguments]
#
# Example:
#   run_rose.sh -g hg38 -i peaks.gff -r chip.bam -o /out

ROSE_MAIN="rose2"

exec "$ROSE_MAIN" "$@"
