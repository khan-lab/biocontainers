# rGREAT

rGREAT (Genomic Regions Enrichment of Annotations Tool) performs functional enrichment
analysis on genomic regions. It supports both the online GREAT web service and a local
implementation of the GREAT algorithm, covering 600+ organisms and numerous gene set
collections.

Based on the official [Bioconductor rGREAT package](https://bioconductor.org/packages/rGREAT)
using `bioconductor/bioconductor_docker` as the base image.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/rgreat:latest
```

## Usage

rGREAT is an R library. Use it via interactive R sessions, R scripts, or the provided wrapper.

### Interactive R session

```bash
docker run --rm -it ghcr.io/khan-lab/rgreat:latest R
```

Then in R:

```r
library(rGREAT)
library(rtracklayer)

# Import genomic regions from a BED file
gr <- import("/data/regions.bed")

# Run local GREAT enrichment (GO Biological Process)
res <- great(gr, "GO:BP", "hg38")

# Get enrichment table
tb <- getEnrichmentTable(res)
head(tb)
```

### Run an R script

```bash
docker run --rm \
    -v /path/to/scripts:/scripts \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/rgreat:latest \
    Rscript /scripts/my_enrichment_analysis.R
```

### Using the wrapper script

The bundled wrapper runs a standard GO:BP enrichment on a BED file:

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/rgreat:latest \
    run_rgreat.sh \
    --bed /data/regions.bed \
    --genome hg38 \
    --outdir /out
```

### Custom gene set collection

```bash
docker run --rm -it \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/rgreat:latest \
    R -e '
library(rGREAT)
gr <- rtracklayer::import("/data/regions.bed")
res <- great(gr, "MSigDB:H", "hg38")
tb <- getEnrichmentTable(res)
write.table(tb, "/out/msigdb_hallmark.tsv", sep="\t", row.names=FALSE, quote=FALSE)
'
```

## Wrapper Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `--bed` | *(required)* | Path to input BED file with genomic regions |
| `--genome` | `hg38` | Reference genome (`hg19` or `hg38`) |
| `--collection` | `GO:BP` | Gene set collection (e.g. `GO:BP`, `GO:MF`, `GO:CC`, `MSigDB:H`) |
| `--outdir` | `/out` | Output directory |

## Wrapper Outputs

| File | Description |
|------|-------------|
| `great_enrichment.tsv` | Enrichment results table (tab-delimited) |
| `great_volcano.pdf` | Volcano plot of enrichment results |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BED / region files | `/data` | Input genomic regions |
| R scripts | `/scripts` | Custom analysis scripts |
| Output directory | `/out` | Enrichment results and plots |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
