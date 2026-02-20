# TelSeq

TelSeq estimates telomere length from whole-genome sequencing (WGS) BAM files.
It counts telomeric reads and normalises for GC-content bias (48–52%) to
produce reliable telomere length estimates.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/telseq:latest
```

## Usage

The `telseq` command is on `PATH` and callable directly.

### Single BAM file

```bash
docker run --rm \
    -v /path/to/data:/data \
    ghcr.io/khan-lab/telseq:latest \
    telseq /data/sample.bam
```

### Multiple BAM files

```bash
docker run --rm \
    -v /path/to/data:/data \
    ghcr.io/khan-lab/telseq:latest \
    telseq /data/sample1.bam /data/sample2.bam
```

### BAM list file

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/telseq:latest \
    telseq -f /data/bamlist.txt -o /out/telomere_lengths.txt
```

### Merge by read group

```bash
docker run --rm \
    -v /path/to/data:/data \
    ghcr.io/khan-lab/telseq:latest \
    telseq -m /data/sample.bam
```

## Key Arguments

| Argument | Description |
|----------|-------------|
| `FILE.bam` | One or more BAM files to analyse |
| `-f FILE` | File listing BAM paths (one per line) |
| `-o FILE` | Write output to file (default: stdout) |
| `-m` | Merge results by read group |
| `-H` | Suppress header in output |
| `-h` | Print header only |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM files | `/data` | Input sequencing data |
| Output directory | `/out` | Results |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
