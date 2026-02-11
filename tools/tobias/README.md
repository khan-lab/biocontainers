# TOBIAS

TOBIAS (Transcription factor Occupancy prediction By Investigation of ATAC-seq Signal)
detects transcription factor binding from ATAC-seq data using footprinting analysis.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/tobias:latest
```

## Usage

### Correct Tn5 bias

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/tobias:latest \
    ATACorrect \
    --bam /data/atac.bam \
    --genome /data/genome.fa \
    --peaks /data/peaks.bed \
    --outdir /out
```

### Calculate footprint scores

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/tobias:latest \
    ScoreBigwig \
    --signal /data/corrected.bw \
    --regions /data/peaks.bed \
    --output /out/footprints.bw
```

### Detect differentially bound TFs

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/tobias:latest \
    BINDetect \
    --motifs /data/motifs.jaspar \
    --signals /data/condition1.bw /data/condition2.bw \
    --genome /data/genome.fa \
    --peaks /data/peaks.bed \
    --outdir /out
```

### Plot aggregate footprints

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/tobias:latest \
    PlotAggregate \
    --TFBS /data/tfbs.bed \
    --signals /data/corrected.bw \
    --output /out/aggregate.pdf
```

### Using the wrapper script

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    --entrypoint run_tobias.sh \
    ghcr.io/khan-lab/tobias:latest \
    ATACorrect --bam /data/atac.bam --genome /data/genome.fa --peaks /data/peaks.bed --outdir /out
```

## Subcommands

| Command | Description |
|---------|-------------|
| `ATACorrect` | Correct Tn5 insertion bias in ATAC-seq |
| `ScoreBigwig` | Calculate footprint scores from corrected signal |
| `BINDetect` | Estimate differentially bound motifs between conditions |
| `PlotAggregate` | Aggregate ATAC-seq signal plots |
| `PlotHeatmap` | Heatmap visualization of ATAC-seq signal |
| `PlotTracks` | IGV-style genomic signal tracks |
| `FormatMotifs` | Convert motif file formats |
| `ClusterMotifs` | Cluster motifs and create consensus |
| `CreateNetwork` | Generate TF-TF binding networks |
| `FilterFragments` | Filter fragments from BAM files |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM / bigWig / BED | `/data` | Input ATAC-seq data, peaks, genome |
| Output directory | `/out` | Corrected signal, footprints, results |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
