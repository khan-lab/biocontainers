# UniBind Enrich

UniBind Enrich performs transcription factor (TF) binding site enrichment
analysis against the [UniBind](https://unibind.uio.no/) database using the
[LOLA](https://bioconductor.org/packages/LOLA/) framework. It supports three
analysis modes and produces ranked enrichment tables along with interactive
and static visualizations.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/unibind-enrich:latest
```

## LOLA Database

UniBind LOLA databases are **not bundled** in the image due to their size
(~800 MB per species). Download the databases for your target species/assembly
from Zenodo ([DOI: 10.5281/zenodo.4704641](https://doi.org/10.5281/zenodo.4704641))
and mount them at `/data/lola`.

Available assemblies: hg38, mm10, Rnor_6.0, GRCz11, dm6, TAIR10, WBcel235,
R64-1-1, ASM294v2.

## Analysis Modes

### Mode 1: Enrichment with a background set (`oneSetBg`)

Use when you have a specific background universe (e.g. all accessible regions).

```bash
docker run --rm \
    -v /path/to/lola_db:/data/lola:ro \
    -v /path/to/beds:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/unibind-enrich:latest \
    UniBind_enrich.sh oneSetBg \
        /data/lola \
        /data/query_regions.bed \
        /data/background.bed \
        /out
```

### Mode 2: Differential enrichment between two sets (`twoSets`)

Compare TF enrichment between two region sets directly.

```bash
docker run --rm \
    -v /path/to/lola_db:/data/lola:ro \
    -v /path/to/beds:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/unibind-enrich:latest \
    UniBind_enrich.sh twoSets \
        /data/lola \
        /data/regions_A.bed \
        /data/regions_B.bed \
        /out
```

### Mode 3: Enrichment without a background (`oneSetNoBg`)

Uses the default UniBind background universe.

```bash
docker run --rm \
    -v /path/to/lola_db:/data/lola:ro \
    -v /path/to/beds:/data:ro \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/unibind-enrich:latest \
    UniBind_enrich.sh oneSetNoBg \
        /data/lola \
        /data/universe.bed \
        /data/query_regions.bed \
        /out
```

### Filter results by cell type

```bash
docker run --rm \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/unibind-enrich:latest \
    UniBind_filter.sh /out /out K562 HepG2
```

## Input Format

All region inputs are standard BED files (chromosome, start, end).

## Output Files

| File | Description |
|------|-------------|
| `allEnrichments.tsv` | Full enrichment table (TF, p-value, metadata) |
| `col_<TFNAME>.tsv` | Per-TF individual result files |
| `allEnrichments_swarm.pdf` | Static beeswarm plot |
| `allEnrichments_swarm.html` | Interactive beeswarm plot |
| `allEnrichments_rank.html` | Interactive ranking plot |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| UniBind LOLA database | `/data/lola` | TF binding database (required) |
| Input BED files | `/data` | Query and background regions |
| Output directory | `/out` | Results and visualizations |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
