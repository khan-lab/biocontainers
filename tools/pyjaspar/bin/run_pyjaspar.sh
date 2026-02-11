#!/usr/bin/env bash
set -euo pipefail

# Wrapper for pyJASPAR inside the container.
# Since pyJASPAR is a Python library (no CLI), this wrapper runs a
# user-provided Python script or starts an interactive Python session.
#
# Usage:
#   run_pyjaspar.sh <script.py> [args...]   Run a Python script
#   run_pyjaspar.sh                          Start interactive Python

if [[ $# -eq 0 ]]; then
    exec python3 -i -c "from pyjaspar import jaspardb; print('pyJASPAR loaded. Use jaspardb() to start.')"
else
    exec python3 "$@"
fi
