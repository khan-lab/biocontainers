#!/usr/bin/env bash
set -euo pipefail

# Wrapper for Dig / DIGDriver inside the container.
#
# DIGDriver needs large external reference data (hg19.fasta plus pretrained
# mutation-map .h5 files, ~3.6 GB+) from http://cb.csail.mit.edu/DIG/downloads/.
# It is NOT baked into this image — download it and mount it at /data.
#
# The primary driver script is DigDriver.py; helper scripts (DigPreprocess.py,
# DigPretrain.py, ...) are also on PATH.
#
#   run_digdriver.sh element_test --help
#
# See: https://github.com/maxwellsh/DIGDriver

if [[ $# -eq 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "Dig / DIGDriver – driver detection via a genome-wide mutation-rate model."
    echo ""
    echo "Reference data (hg19.fasta + pretrained .h5 maps, ~3.6 GB+) is not bundled;"
    echo "download it from http://cb.csail.mit.edu/DIG/downloads/ and mount at /data."
    echo ""
    exec DigDriver.py --help
fi

exec DigDriver.py "$@"
