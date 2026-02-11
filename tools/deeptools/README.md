# deepTools

A suite of tools for exploring deep-sequencing data. Provides utilities for BAM/bigWig
processing, quality control, normalization, and visualization.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/deeptools:latest
```

## Usage

deepTools provides many individual commands. Override the entrypoint to use them directly.

### Generate a bigWig coverage track

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    --entrypoint bamCoverage \
    ghcr.io/khan-lab/deeptools:latest \
    -b /data/sample.bam \
    -o /out/coverage.bw \
    --normalizeUsing RPKM
```

### Compute signal matrix around TSS

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    --entrypoint computeMatrix \
    ghcr.io/khan-lab/deeptools:latest \
    reference-point \
    -S /data/signal.bw \
    -R /data/genes.bed \
    -o /out/matrix.gz \
    --referencePoint TSS \
    -a 3000 -b 3000
```

### Plot a heatmap

```bash
docker run --rm \
    -v /path/to/output:/out \
    --entrypoint plotHeatmap \
    ghcr.io/khan-lab/deeptools:latest \
    -m /out/matrix.gz \
    -o /out/heatmap.pdf
```

### Multi-sample correlation

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    --entrypoint multiBamSummary \
    ghcr.io/khan-lab/deeptools:latest \
    bins \
    -b /data/sample1.bam /data/sample2.bam \
    -o /out/results.npz
```

### Using the wrapper script

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    --entrypoint run_deeptools.sh \
    ghcr.io/khan-lab/deeptools:latest \
    bamCoverage -b /data/sample.bam -o /out/coverage.bw
```

## Available Commands

| Category | Commands |
|----------|----------|
| BAM/bigWig | `bamCoverage`, `bamCompare`, `bigwigCompare`, `bigwigAverage`, `multiBamSummary`, `multiBigwigSummary` |
| QC | `plotCorrelation`, `plotPCA`, `plotFingerprint`, `bamPEFragmentSize`, `plotCoverage` |
| Heatmaps | `computeMatrix`, `plotHeatmap`, `plotProfile` |
| Other | `correctGCBias`, `alignmentSieve`, `estimateReadFiltering` |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM / bigWig files | `/data` | Input sequencing data |
| Output directory | `/out` | Coverage tracks, matrices, plots |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
