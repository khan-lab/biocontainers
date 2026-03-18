# ReMapEnrich

ReMapEnrich performs genomic region enrichment analysis against the
[ReMap](https://remap.univ-amu.fr/) transcription factor binding catalog.
Given a BED file of query regions, it identifies TFs whose binding sites are
significantly enriched using Fisher's exact test, returning p-values, q-values,
and effect sizes.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/remapennrich:latest
```

## Usage

### Basic enrichment (downloads ReMap catalog automatically)

```bash
docker run --rm \
    -v /path/to/beds:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/remapennrich:latest \
    Rscript /usr/local/bin/run_remapennrich.R \
        --bed /data/query_regions.bed \
        --genome hg38 \
        --out /out/enrichment.tsv
```

The ReMap catalog (~500 MB) is downloaded automatically the first time for the
specified genome assembly.

### Use a pre-downloaded catalog

To avoid repeated downloads, mount a pre-downloaded catalog BED file:

```bash
docker run --rm \
    -v /path/to/beds:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/remapennrich:latest \
    Rscript /usr/local/bin/run_remapennrich.R \
        --bed /data/query_regions.bed \
        --catalog /data/remap2022_hg38.bed \
        --out /out/enrichment.tsv
```

### Adjust p-value cutoff

```bash
docker run --rm \
    -v /path/to/beds:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/remapennrich:latest \
    Rscript /usr/local/bin/run_remapennrich.R \
        --bed /data/query_regions.bed \
        --genome hg38 \
        --pval 0.01 \
        --out /out/enrichment_strict.tsv
```

### Interactive R session

```bash
docker run --rm -it \
    -v /path/to/beds:/data \
    ghcr.io/khan-lab/remapennrich:latest \
    R
```

```r
library(ReMapEnrich)
library(GenomicRanges)

query   <- bedToGranges("/data/query_regions.bed")
catalog <- downloadRemapCatalog("hg38")
result  <- enrichment(query, catalog)

# Visualize
enrichmentDotPlot(result)
enrichmentBarPlot(result)
enrichmentVolcanoPlot(result)
```

## Key Arguments

| Argument | Description |
|----------|-------------|
| `--bed FILE` | Input BED file of query genomic regions (required) |
| `--genome STR` | Assembly: `hg38`, `hg19`, `mm10`, `dm6`, `ce11`, `rn5` (default: `hg38`) |
| `--catalog FILE` | Custom catalog BED (skips ReMap download) |
| `--pval FLOAT` | p-value cutoff for output rows (default: `0.05`) |
| `--out FILE` | Output TSV path (default: `/out/enrichment.tsv`) |

## Input Format

Standard BED file (chromosome, start, end):

```
chr1    1000000    1001000
chr1    2000000    2001500
chr2    5000000    5002000
```

## Output Format

Tab-separated file with one row per enriched TF:

| Column | Description |
|--------|-------------|
| `TF` | Transcription factor name |
| `pvalue` | Fisher's exact test p-value |
| `qvalue` | BH-adjusted q-value |
| `b` | Overlap count |
| `nPeaks` | Query region count |
| `catalog_size` | TF binding site count in catalog |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| Input BED files | `/data` | Query regions (and optional catalog) |
| Output directory | `/out` | Enrichment TSV results |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
