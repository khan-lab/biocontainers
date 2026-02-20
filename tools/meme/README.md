# MEME Suite

MEME Suite is a comprehensive collection of tools for motif-based sequence
analysis. It provides motif discovery, scanning, enrichment analysis, and
comparison for DNA, RNA, and protein sequences.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/meme:latest
```

## Pre-installed Databases

The image includes the **Motif Databases** (v12.27) and **GOMo Databases** (v3.2)
out of the box at `/opt/meme/db/`. These contain curated motif collections such as
JASPAR, HOCOMOCO, CIS-BP, UniPROBE, and GO associations for GOMo analysis.

Databases are located at:
- `/opt/meme/db/motif_databases/` – motif database files (MEME format)
- `/opt/meme/db/gomo_databases/` – GOMo gene ontology databases

**Sequence databases** are not included due to their large size. If needed, mount
them at runtime:

```bash
docker run --rm \
    -v /path/to/seq_databases:/db/seq \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/meme:latest \
    <command> [args...]
```

Download sequence databases from https://meme-suite.org/meme/doc/download.html.

## Usage

All MEME Suite commands are on `PATH` and callable directly.

### De novo motif discovery

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/meme:latest \
    meme /data/sequences.fa -dna -o /out/meme_results -nmotifs 10
```

### Scan sequences for motif occurrences (FIMO)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/meme:latest \
    fimo --o /out/fimo_results \
        /opt/meme/db/motif_databases/JASPAR/JASPAR2024_CORE_non-redundant_pfms_meme.txt \
        /data/sequences.fa
```

### Compare motifs to a database (Tomtom)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/meme:latest \
    tomtom -o /out/tomtom_results \
        /data/query_motifs.meme \
        /opt/meme/db/motif_databases/HUMAN/HOCOMOCOv11_core_HUMAN_mono_meme_format.meme
```

### Motif enrichment analysis (AME)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/meme:latest \
    ame --o /out/ame_results --control --shuffle-- \
        /data/sequences.fa \
        /opt/meme/db/motif_databases/JASPAR/JASPAR2024_CORE_non-redundant_pfms_meme.txt
```

### Simple enrichment analysis (SEA)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/meme:latest \
    sea --p /data/peaks.fa \
        --m /opt/meme/db/motif_databases/JASPAR/JASPAR2024_CORE_non-redundant_pfms_meme.txt \
        --o /out/sea_results
```

### Comprehensive ChIP-seq analysis (MEME-ChIP)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/meme:latest \
    meme-chip -db /opt/meme/db/motif_databases/JASPAR/JASPAR2024_CORE_non-redundant_pfms_meme.txt \
        -o /out/meme_chip_results /data/peaks.fa
```

### Discover enriched motifs (STREME)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/meme:latest \
    streme --p /data/sequences.fa --o /out/streme_results
```

## Main Commands

| Command | Description |
|---------|-------------|
| `meme` | De novo ungapped motif discovery |
| `streme` | Discover enriched motifs in large datasets |
| `fimo` | Scan sequences for individual motif occurrences |
| `tomtom` | Compare query motifs against a target database |
| `ame` | Motif enrichment analysis |
| `sea` | Simple enrichment analysis of known motifs |
| `meme-chip` | Comprehensive ChIP-seq motif analysis pipeline |
| `xstreme` | Comprehensive motif analysis for any sequences |
| `centrimo` | Local motif enrichment in fixed-width sequences |
| `glam2` | Gapped motif discovery |
| `mcast` | Search for motif clusters in sequences |
| `spamo` | Find motifs with preferred spacings |
| `gomo` | Predict gene function via motif–GO associations |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| Sequence files (FASTA) | `/data` | Input sequences |
| Output directory | `/out` | Results and reports |
| Sequence databases (optional) | `/db/seq` | Large sequence databases (not pre-installed) |

Pre-installed database paths (inside the image):
- `/opt/meme/db/motif_databases/` – Motif Databases v12.27
- `/opt/meme/db/gomo_databases/` – GOMo Databases v3.2

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
