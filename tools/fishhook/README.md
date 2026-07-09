# fishHook

[fishHook](https://github.com/mskilab-org/fishHook) detects enrichment or depletion of
somatic mutations in arbitrary genomic intervals (genes, elements, tiles) relative to a
covariate-corrected background model, for coding and noncoding cancer driver discovery.

- **Upstream:** https://github.com/mskilab-org/fishHook (no release; built from `master`,
  together with its dependency `mskilab-org/gUtils`)
- **License:** GPL family (DESCRIPTION says GPL-2; README says GPL-3)
- **Image:** `ghcr.io/khan-lab/fishhook`
- **Platform:** `linux/amd64` + `linux/arm64`

## Pull

```bash
docker pull ghcr.io/khan-lab/fishhook:latest
```

## Usage

fishHook is an R library with no command-line interface. Run an analysis script:

```bash
docker run --rm -v "$PWD:/data" ghcr.io/khan-lab/fishhook /data/analysis.R
```

Your script loads `library(fishHook)` and supplies mutation events, target intervals,
an eligible/callable territory, and covariate tracks (replication timing, chromatin,
sequence context). Tutorial example data is available from mskilab.com.

## Notes

- Runs as non-root `biouser`; mount inputs at `/data`, write output to `/out`.
