# ActiveDriverWGS

[ActiveDriverWGS](https://github.com/reimandlab/ActiveDriverWGSR) detects cancer driver
elements in coding and noncoding regions by testing user-supplied genomic elements for an
enrichment of somatic mutations against a local background, accounting for trinucleotide
mutation signatures.

- **Upstream:** https://github.com/reimandlab/ActiveDriverWGSR (CRAN package `ActiveDriverWGS` 1.2.1)
- **License:** GPL-3.0-or-later
- **Image:** `ghcr.io/khan-lab/activedriverwgs`
- **Platform:** `linux/amd64` + `linux/arm64`

## Pull

```bash
docker pull ghcr.io/khan-lab/activedriverwgs:latest
```

## Reference data (required at runtime)

The main `ActiveDriverWGS()` function needs a `BSgenome` package matching the chosen
reference (e.g. `BSgenome.Hsapiens.UCSC.hg19` or `.hg38`, ~700 MB each). These are **not**
bundled; install the one you need in a derived image, e.g.:

```dockerfile
FROM ghcr.io/khan-lab/activedriverwgs:latest
RUN Rscript -e 'BiocManager::install("BSgenome.Hsapiens.UCSC.hg38", ask=FALSE)'
```

## Usage

```bash
# Run an analysis script mounted into the container
docker run --rm -v "$PWD:/data" ghcr.io/khan-lab/activedriverwgs /data/analysis.R
```

Your script calls `ActiveDriverWGS(mutations = ..., elements = ..., ref_genome = ...)`.

## Notes

- Runs as non-root `biouser`; mount inputs at `/data`, write output to `/out`.
