# shallowHRD

shallowHRD detects homologous recombination deficiency (HRD) from shallow
whole-genome sequencing (≥0.3× coverage). It takes a copy number ratio file
(from ControlFREEC or QDNAseq) and computes a genome-wide HRD score using
segmentation statistics. Cytoband reference files for hg19 and hg38 are
bundled in the image.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/shallowhrd:latest
```

## Input Format

The ratio file is tab-delimited with four columns (output of ControlFREEC or
a QDNAseq ratio export):

```
Chromosome  Start     Ratio   RatioMedian
1           1         0.982   0.995
1           50001     1.034   0.995
...
```

## Usage

### hg38 (default for most new analyses)

```bash
docker run --rm \
    -v /path/to/data:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/shallowhrd:latest \
    run_shallowhrd.sh hg38 /data/sample_ratio.txt /out
```

### hg19

```bash
docker run --rm \
    -v /path/to/data:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/shallowhrd:latest \
    run_shallowhrd.sh hg19 /data/sample_ratio.txt /out
```

### Custom cytoband file

```bash
docker run --rm \
    -v /path/to/data:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/shallowhrd:latest \
    run_shallowhrd.sh hg38 /data/ratio.txt /out /data/custom_cytoband.csv
```

## Arguments

| Argument | Description |
|----------|-------------|
| `genome` | Reference genome: `hg19` or `hg38` |
| `ratio_file` | ControlFREEC/QDNAseq ratio file (required) |
| `output_dir` | Output directory for results (required) |
| `cytoband_file` | Custom cytoband CSV (optional; bundled files used by default) |

## Bundled Reference Files

| File | Location |
|------|----------|
| hg19 cytoband | `/opt/shallowhrd/cytoBand_adapted_hg19.csv` |
| hg38 cytoband | `/opt/shallowhrd/cytoBand_adapted_hg38.csv` |

## Output Files

| File | Description |
|------|-------------|
| `*_HRD_results.txt` | HRD score and classification (HRD/HRP) |
| `*_segmentation.pdf` | Genome-wide copy number plot |
| `*_HRD_plot.pdf` | HRD score visualization |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| Ratio files | `/data` | Input copy number ratio data |
| Output directory | `/out` | HRD results and plots |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
