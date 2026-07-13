# MutSpot

[MutSpot](https://github.com/skandlab/MutSpot) detects recurrently mutated hotspot regions
in the noncoding genome, fitting a LASSO-selected background mutation-rate model from
sequence and epigenomic features and testing for local mutation recurrence.

- **Upstream:** https://github.com/skandlab/MutSpot (no release; built from `master`,
  package `MutSpot_Rpackage`)
- **License:** none declared upstream (no LICENSE file). Treated as all-rights-reserved
  academic source — image is published for internal/research use only.
- **Image:** `ghcr.io/khan-lab/mutspot`
- **Platform:** `linux/amd64` only (pins `rocker/r-ver:3.6.3`, which is amd64-only).

## Pull

```bash
docker pull ghcr.io/khan-lab/mutspot:latest
```

## Usage

MutSpot is an R library with no command-line interface. Run an analysis script:

```bash
docker run --rm -v "$PWD:/data" ghcr.io/khan-lab/mutspot /data/analysis.R
```

Your script loads `library(MutSpot)` and supplies mutation MAF files plus epigenomic
feature tracks. The `BSgenome.Hsapiens.UCSC.hg19` / `.hg38` data packages are bundled.

## Notes

- Runs as non-root `biouser`; mount inputs at `/data`, write output to `/out`.
- The image is large (pinned 2020-era R/Bioconductor stack + two BSgenome packages).
