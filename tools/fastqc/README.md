# FastQC

Quality control tool for high-throughput sequencing data.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/fastqc:latest
```

## Usage

### Basic QC report

```bash
docker run --rm \
    -v /path/to/reads:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/fastqc:latest \
    /data/sample.fastq.gz --outdir /out
```

### Multiple files

```bash
docker run --rm \
    -v /path/to/reads:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/fastqc:latest \
    /data/*.fastq.gz --outdir /out --threads 4
```

### Using the wrapper script

```bash
docker run --rm \
    -v /path/to/reads:/data \
    -v /path/to/output:/out \
    --entrypoint run_fastqc.sh \
    ghcr.io/khan-lab/fastqc:latest \
    /data/sample.fastq.gz /out
```

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| Input FASTQ directory | `/data` | Sequencing reads |
| Output directory | `/out` | QC reports (HTML + zip) |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
