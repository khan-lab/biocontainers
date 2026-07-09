# ncdDetect2

[ncdDetect2](https://github.com/TobiasMadsen/ncdDetect2) detects candidate noncoding
cancer driver elements by comparing the observed mutational impact in a region against a
null distribution derived from a per-site, per-sample multinomial mutation-rate model.

- **Upstream:** https://github.com/TobiasMadsen/ncdDetect2 (no release; built from `master`)
- **License:** none declared upstream (no LICENSE file). Treated as all-rights-reserved
  academic source — image is published for internal/research use only.
- **Image:** `ghcr.io/khan-lab/ncddetect`
- **Platform:** `linux/amd64` + `linux/arm64`

## Pull

```bash
docker pull ghcr.io/khan-lab/ncddetect:latest
```

## Usage

ncdDetect2 is an R library with no command-line interface. Run an analysis script:

```bash
docker run --rm -v "$PWD:/data" ghcr.io/khan-lab/ncddetect /data/analysis.R
```

Your script loads `library(ncdDetect2)` and supplies somatic mutation calls plus
per-site/per-sample covariate tracks (replication timing, expression, sequence context).

## Notes

- Runs as non-root `biouser`; mount inputs at `/data`, write output to `/out`.
