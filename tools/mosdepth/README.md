# mosdepth

mosdepth calculates sequencing depth from BAM and CRAM files using a fast
streaming algorithm. It produces per-base depth, windowed depth, and
region-based depth output as compressed BED files, plus a global coverage
distribution summary. Single-threaded WGS at 30× depth runs in ~25 minutes.

## Quick Start

**Docker:**
```bash
docker pull ghcr.io/khan-lab/mosdepth:latest
```

**Singularity:**
```bash
singularity pull mosdepth.sif docker://ghcr.io/khan-lab/mosdepth:latest
```

## Usage

### Per-base depth (WGS)

**Docker:**
```bash
docker run --rm \
    -v /path/to/bams:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/mosdepth:latest \
    mosdepth /out/sample /data/sample.bam
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/bams:/data \
    --bind /path/to/output:/out \
    mosdepth.sif \
    mosdepth /out/sample /data/sample.bam
```

### Windowed depth — skip per-base output (recommended for WGS speed)

**Docker:**
```bash
docker run --rm \
    -v /path/to/bams:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/mosdepth:latest \
    mosdepth --no-per-base --by 500 /out/sample /data/sample.bam
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/bams:/data \
    --bind /path/to/output:/out \
    mosdepth.sif \
    mosdepth --no-per-base --by 500 /out/sample /data/sample.bam
```

### Region-based depth from a BED file (exome/panel)

**Docker:**
```bash
docker run --rm \
    -v /path/to/data:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/mosdepth:latest \
    mosdepth --by /data/targets.bed /out/sample /data/sample.bam
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    --bind /path/to/output:/out \
    mosdepth.sif \
    mosdepth --by /data/targets.bed /out/sample /data/sample.bam
```

### CRAM input (requires reference FASTA)

**Docker:**
```bash
docker run --rm \
    -v /path/to/data:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/mosdepth:latest \
    mosdepth --fasta /data/reference.fa /out/sample /data/sample.cram
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    --bind /path/to/output:/out \
    mosdepth.sif \
    mosdepth --fasta /data/reference.fa /out/sample /data/sample.cram
```

### Coverage thresholds (callable regions)

**Docker:**
```bash
docker run --rm \
    -v /path/to/bams:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/mosdepth:latest \
    mosdepth -n --by 500 --thresholds 1,10,20,30 /out/sample /data/sample.bam
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/bams:/data \
    --bind /path/to/output:/out \
    mosdepth.sif \
    mosdepth -n --by 500 --thresholds 1,10,20,30 /out/sample /data/sample.bam
```

### Multithreading (BAM decompression)

```bash
mosdepth --threads 3 -n --by 500 /out/sample /data/sample.bam
```

## Key Arguments

| Argument | Description |
|----------|-------------|
| `<prefix>` | Output file prefix (required) |
| `<BAM/CRAM>` | Input alignment file (required; must be indexed) |
| `-b/--by FILE\|INT` | BED file for region depth, or window size in bp |
| `-n/--no-per-base` | Skip per-base depth output (faster for WGS) |
| `-x/--fast-mode` | Skip CIGAR parsing (use for speed over precision) |
| `-t/--threads INT` | BAM decompression threads (default: 0) |
| `-f/--fasta FILE` | Reference FASTA (required for CRAM) |
| `-T/--thresholds X,Y` | Report bases above each threshold depth |
| `-q/--quantize X:Y:Z` | Bin coverage into segments |
| `--mapq INT` | Minimum mapping quality filter |

## Output Files

| File | Description |
|------|-------------|
| `<prefix>.mosdepth.global.dist.txt` | Cumulative coverage distribution |
| `<prefix>.mosdepth.summary.txt` | Mean depth per chromosome and total |
| `<prefix>.per-base.bed.gz` | Per-position depth (unless `-n`) |
| `<prefix>.regions.bed.gz` | Mean depth per region (with `--by`) |
| `<prefix>.quantized.bed.gz` | Coverage bins (with `--quantize`) |
| `<prefix>.thresholds.bed.gz` | Bases above thresholds (with `-T`) |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM/CRAM files + reference | `/data` | Input alignments |
| Output directory | `/out` | Depth BED files and summary |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
