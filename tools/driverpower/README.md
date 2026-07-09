# DriverPower

[DriverPower](https://github.com/smshuai/DriverPower) identifies coding and noncoding
cancer driver elements by combining functional impact scores with a background
mutation-rate model (regularised regression over genomic covariates) to test elements for
excess mutational burden.

- **Upstream:** https://github.com/smshuai/DriverPower (v1.0.2, 2018)
- **License:** GPL-3.0-or-later
- **Image:** `ghcr.io/khan-lab/driverpower`
- **Platform:** `linux/amd64` only (pinned 2018-era scientific stack — scikit-learn 0.19.2
  etc. — whose wheels are amd64-only). Installed from PyPI on a Python 3.7 base.

## Pull

```bash
docker pull ghcr.io/khan-lab/driverpower:latest
```

## Reference data (required at runtime)

DriverPower needs precomputed feature/covariate matrices (HDF5), callable regions and
element definitions (hg19). The tutorial dataset is **~13 GB** and is **not** baked into
the image — download it from upstream and mount it at `/data`.

## Usage

```bash
docker run --rm -v "$PWD:/data" -v "$PWD/out:/out" ghcr.io/khan-lab/driverpower \
    infer --feature /data/test.h5 --model /data/model.pkl -o /out
```

## Help

```bash
docker run --rm ghcr.io/khan-lab/driverpower --help
```

## Notes

- Runs as non-root `biouser`; mount inputs at `/data`, write output to `/out`.
