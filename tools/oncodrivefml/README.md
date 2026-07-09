# OncodriveFML

[OncodriveFML](https://github.com/bbglab/oncodrivefml) detects signals of positive
selection in somatic mutations by aggregating the **functional impact** of mutations
(e.g. CADD scores) across genomic elements — genes, promoters, enhancers, etc. — to
nominate candidate cancer driver elements in both coding and noncoding regions.

- **Upstream:** https://github.com/bbglab/oncodrivefml
- **Version:** 2.5.0
- **License:** AGPL-3.0-or-later. Commercial use/redistribution requires a separate
  license from Universitat Pompeu Fabra (see the upstream `LICENSING.txt`). The CADD
  functional-impact scores it uses are for non-commercial use only.
- **Image:** `ghcr.io/khan-lab/oncodrivefml`

## Pull

```bash
docker pull ghcr.io/khan-lab/oncodrivefml:latest
```

## Reference data (required at runtime)

OncodriveFML relies on a reference genome and functional-impact scores that the
`bgdata` library downloads automatically on first use into `~/.bgdata`. The CADD
scores are **~17 GB**, so they are **not** baked into the image. Mount a persistent
cache directory and point `BGDATA_LOCAL` at it so the download happens once:

```bash
mkdir -p bgdata_cache out
docker run --rm \
    -e BGDATA_LOCAL=/data/bgdata \
    -v "$PWD/bgdata_cache:/data/bgdata" \
    -v "$PWD:/data" -v "$PWD/out:/out" \
    ghcr.io/khan-lab/oncodrivefml \
    -i /data/mutations.tsv \
    -e /data/regions.tsv \
    -t coding \
    -c /data/oncodrivefml_v2.conf \
    -o /out
```

Inputs (`-i` mutations, `-e` elements/regions) and the config (`-c`) come from your
own analysis; the `example/` folder in the upstream repo has a small PAAD dataset and
a template config (`oncodrivefml_v2.conf`).

## Help

```bash
docker run --rm ghcr.io/khan-lab/oncodrivefml --help
```

## Notes

- The container runs as a non-root user (`biouser`); `/data` (input) and `/out`
  (output) are the intended mount points.
- Built for `linux/amd64` and `linux/arm64`.
