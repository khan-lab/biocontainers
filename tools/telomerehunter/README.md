# TelomereHunter

TelomereHunter estimates telomere content and composition from whole-genome
sequencing (WGS) data. It extracts, sorts, and analyses telomeric reads from
tumor and/or control BAM files, enabling characterisation of telomere
maintenance mechanisms in cancer genomes.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/telomerehunter:latest
```

## Usage

The `telomerehunter` command is on `PATH` and callable directly.

### Tumor with matched control

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/telomerehunter:latest \
    telomerehunter -ibt /data/tumor.bam -ibc /data/control.bam \
        -o /out -p sample1
```

### Tumor only

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/telomerehunter:latest \
    telomerehunter -ibt /data/tumor.bam -o /out -p sample1
```

### Run in parallel mode

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/telomerehunter:latest \
    telomerehunter -ibt /data/tumor.bam -ibc /data/control.bam \
        -o /out -p sample1 -pl
```

## Key Arguments

| Argument | Description |
|----------|-------------|
| `-ibt FILE` | Path to indexed tumor BAM file (required) |
| `-ibc FILE` | Path to indexed control BAM file (optional) |
| `-o DIR` | Output directory (required) |
| `-p NAME` | Sample name for output files and diagrams (required) |
| `-pl` | Run filtering/sorting/estimating in parallel |
| `-d` | Remove reads marked as duplicates |
| `-mqt INT` | Mapping quality threshold (default: 8) |
| `-pff FORMAT` | Plot file format: pdf, png, svg, or all |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM files | `/data` | Input sequencing data |
| Output directory | `/out` | Results and diagrams |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
