# HOMER

HOMER (Hypergeometric Optimization of Motif EnRichment) is a comprehensive suite for
motif discovery, ChIP-seq / ATAC-seq peak finding, annotation, and next-gen sequencing
data analysis. It provides de novo and known motif enrichment analysis as well as tools
for creating tag directories, calling peaks, and annotating genomic regions.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/homer:latest
```

## Usage

All HOMER commands are on `PATH` and callable directly.

### De novo motif discovery

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/homer:latest \
    findMotifsGenome.pl /data/peaks.bed hg38 /out -size 200 -mask
```

### Annotate peaks

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/homer:latest \
    annotatePeaks.pl /data/peaks.bed hg38 > /out/annotated.tsv
```

### Create tag directory from BAM

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/homer:latest \
    makeTagDirectory /out/tags /data/sample.bam
```

### Find peaks

```bash
docker run --rm \
    -v /path/to/tags:/tags \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/homer:latest \
    findPeaks /tags -style factor -o /out/peaks.txt
```

### Known motif enrichment

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/homer:latest \
    findMotifsGenome.pl /data/peaks.bed hg38 /out -size 200 -mask -nomotif
```

## Pre-installed Genomes

The image includes **hg38** and **mm10** genome data out of the box. No additional
setup is needed for these two genomes.

To install additional genomes at runtime, use a persistent Docker volume:

```bash
docker run --rm \
    -v homer_data:/opt/homer/data \
    ghcr.io/khan-lab/homer:latest \
    perl /opt/homer/configureHomer.pl -install mm39

# Use the same -v homer_data:/opt/homer/data in subsequent commands
```

Available genomes include: `hg18`, `hg19`, `hg38`, `mm8`, `mm9`, `mm10`, `mm39`,
`dm3`, `dm6`, `sacCer3`, and many more.

## Main Commands

| Command | Description |
|---------|-------------|
| `findMotifsGenome.pl` | De novo and known motif enrichment in genomic regions |
| `findMotifs.pl` | General motif discovery on sequences |
| `annotatePeaks.pl` | Annotate peaks/regions with genomic features |
| `makeTagDirectory` | Create tag directory from alignment files |
| `findPeaks` | Call peaks from tag directories |
| `mergePeaks` | Merge overlapping peak files |
| `getDifferentialPeaks` | Find differential peaks between samples |
| `analyzeRepeats.pl` | Quantify expression across repeats/genes |
| `pos2bed.pl` | Convert HOMER peak format to BED |
| `bed2pos.pl` | Convert BED format to HOMER peak format |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM / BED / peak files | `/data` | Input sequencing data |
| Output directory | `/out` | Results, motifs, annotations |
| Genome data (volume, optional) | `/opt/homer/data` | Additional HOMER genomes beyond hg38/mm10 |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
