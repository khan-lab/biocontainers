# MACS3

MACS3 (Model-based Analysis of ChIP-Seq, version 3) identifies transcription factor
binding sites and histone modification enriched regions from ChIP-seq and ATAC-seq data.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/macs3:latest
```

## Usage

### Narrow peak calling (ChIP-seq)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/macs3:latest \
    callpeak \
    -t /data/treatment.bam \
    -c /data/control.bam \
    -f BAM \
    -g hs \
    -n sample \
    --outdir /out
```

### Broad peak calling (histone marks)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/macs3:latest \
    callpeak \
    -t /data/treatment.bam \
    -c /data/control.bam \
    -f BAM \
    -g hs \
    --broad \
    -n sample_broad \
    --outdir /out
```

### ATAC-seq peak calling

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/macs3:latest \
    callpeak \
    -t /data/atac.bam \
    -f BAMPE \
    -g hs \
    --nomodel \
    --shift -100 --extsize 200 \
    -n atac_peaks \
    --outdir /out
```

### HMMRATAC (ATAC-seq with HMM)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/macs3:latest \
    hmmratac \
    -i /data/atac.bam \
    -n hmmratac_out \
    --outdir /out
```

### Using the wrapper script

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    --entrypoint run_macs3.sh \
    ghcr.io/khan-lab/macs3:latest \
    callpeak -t /data/treatment.bam -g hs -n sample --outdir /out
```

## Subcommands

| Command | Description |
|---------|-------------|
| `callpeak` | Main peak calling (narrow and broad) |
| `bdgpeakcall` | Call peaks from bedGraph |
| `bdgbroadcall` | Call broad peaks from bedGraph |
| `bdgcmp` | Compare two bedGraph signal tracks |
| `bdgopt` | Operate on bedGraph scores |
| `cmbreps` | Combine replicates |
| `filterdup` | Remove duplicate reads |
| `hmmratac` | HMM-based ATAC-seq analysis |
| `pileup` | Pileup aligned reads |
| `predictd` | Predict fragment size |
| `randsample` | Random sample from BAM |
| `refinepeak` | Refine peak summits |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM / BED files | `/data` | Input ChIP/ATAC-seq data |
| Output directory | `/out` | Peaks, bedGraphs, summits |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
