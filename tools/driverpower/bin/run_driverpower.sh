#!/usr/bin/env bash
set -euo pipefail

# Wrapper for DriverPower inside the container.
#
# Usage: run_driverpower.sh <model|infer> [args...]
#
# DriverPower needs precomputed feature/covariate matrices (HDF5) plus callable
# regions and element definitions (hg19). The example dataset is ~13 GB and is
# downloaded separately, not baked into this image — mount it at /data.
#
#   run_driverpower.sh model  --feature /data/train.h5 --response /data/counts.tsv ...
#   run_driverpower.sh infer  --feature /data/test.h5  --model /data/model.pkl ... -o /out
#
# See: https://github.com/smshuai/DriverPower

if [[ $# -eq 0 ]]; then
    exec driverpower --help
fi

exec driverpower "$@"
