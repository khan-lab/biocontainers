#!/usr/bin/env bash
set -euo pipefail

# Wrapper for ROSE super-enhancer identification.
# Forwards all arguments to ROSE_main.py from /opt/rose.
#
# Usage: run_rose.sh [ROSE arguments]
#
# Example:
#   run_rose.sh -g hg38 -i peaks.gff -r chip.bam -o /out

ROSE_DIR="/opt/rose"
ROSE_MAIN="${ROSE_DIR}/ROSE_main.py"

if [[ ! -f "$ROSE_MAIN" ]]; then
    echo "ERROR: ROSE_main.py not found at ${ROSE_MAIN}" >&2
    echo "Ensure ROSE is installed in /opt/rose or bind-mount your copy." >&2
    exit 1
fi

# Create default output directory if it doesn't exist
mkdir -p /out 2>/dev/null || true

exec python3 "$ROSE_MAIN" "$@"
