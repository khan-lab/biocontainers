# QDNAseq

QDNAseq performs quantitative DNA sequencing for chromosomal aberrations using
shallow whole-genome sequencing (sWGS) data. It bins, corrects, and segments
read counts to detect copy number variations (CNVs).

## Quick Start

```bash
docker pull ghcr.io/khan-lab/qdnaseq:latest
```

## Usage

### Basic CNV calling

```bash
docker run --rm \
    -v /path/to/bams:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/qdnaseq:latest \
    --bam /data/sample.bam \
    --genome hg19 \
    --binSize 15 \
    --outdir /out
```

### Custom bin size

```bash
docker run --rm \
    -v /path/to/bams:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/qdnaseq:latest \
    --bam /data/sample.bam \
    --genome hg19 \
    --binSize 30 \
    --outdir /out
```

### Using the R script directly

```bash
docker run --rm \
    -v /path/to/bams:/data \
    -v /path/to/output:/out \
    --entrypoint Rscript \
    ghcr.io/khan-lab/qdnaseq:latest \
    /opt/bin/run_qdnaseq.R \
    --bam /data/sample.bam --genome hg19 --binSize 15 --outdir /out
```

## Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `--bam` | *(required)* | Path to input BAM file |
| `--genome` | `hg19` | Reference genome (`hg19` or `hg38`) |
| `--binSize` | `15` | Bin size in kbp |
| `--outdir` | `/out` | Output directory |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM files | `/data` | Input BAM(s) |
| Output directory | `/out` | CNV results, plots |

## Outputs

| File | Description |
|------|-------------|
| `counts_raw.rds` | Raw binned read counts |
| `counts_corrected.rds` | GC-corrected and normalized counts |
| `segments.rds` | CBS segmentation results |
| `segments.tsv` | Segmentation table (tab-delimited) |
| `cnv_plot.pdf` | Copy number profile plot |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
