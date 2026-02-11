# ROSE

ROSE (Rank Ordering of Super-Enhancers) identifies super-enhancers from ChIP-seq data.

This container wraps the [St. Jude ROSE fork](https://github.com/stjude/ROSE) with all
required dependencies (Python 3, bedtools, samtools, R) pre-installed.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/rose:latest
```

## Usage

### Identify super-enhancers

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/genome:/genome \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/rose:latest \
    -g hg38 \
    -i /data/peaks.gff \
    -r /data/input.bam \
    -o /out
```

### With control BAM

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/genome:/genome \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/rose:latest \
    -g hg38 \
    -i /data/peaks.gff \
    -r /data/chip.bam \
    -c /data/control.bam \
    -o /out
```

### Using the wrapper script directly

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    --entrypoint run_rose.sh \
    ghcr.io/khan-lab/rose:latest \
    -g hg38 -i /data/peaks.gff -r /data/chip.bam -o /out
```

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM / peak files | `/data` | Input ChIP-seq data |
| Genome annotations | `/genome` | Reference genome files |
| Output directory | `/out` | ROSE results |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |

## Notes

- ROSE is cloned from `https://github.com/stjude/ROSE` into `/opt/rose`.
- If you use a custom ROSE fork, rebuild the image with `--build-arg ROSE_REPO=<url>`.
