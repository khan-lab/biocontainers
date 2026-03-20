# WisecondorX

WisecondorX detects copy number alterations (CNAs) from shallow
whole-genome sequencing (sWGS) data using a within-sample normalisation
approach. It supports germline CNA calling, somatic tumour analysis, and
non-invasive prenatal testing (NIPT).

## Quick Start

**Docker:**
```bash
docker pull ghcr.io/khan-lab/wisecondorx:latest
```

**Singularity:**
```bash
singularity pull wisecondorx.sif docker://ghcr.io/khan-lab/wisecondorx:latest
```

## Usage

WisecondorX follows a three-step workflow:
1. **convert** — convert each BAM/CRAM to an NPZ binary
2. **newref** — build a reference from a set of control NPZ files
3. **predict** — call CNAs in a test sample against the reference

### Step 1: Convert BAM to NPZ

**Docker:**
```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/wisecondorx:latest \
    WisecondorX convert \
        /data/sample.bam \
        /out/sample.npz \
        --binsize 5000
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    --bind /path/to/output:/out \
    wisecondorx.sif \
    WisecondorX convert \
        /data/sample.bam \
        /out/sample.npz \
        --binsize 5000
```

> **Note:** Do **not** pre-filter reads by mapping quality before conversion.
> WisecondorX relies on low-quality reads to distinguish informative from
> non-informative bins.

### Step 2: Build a reference

Run `convert` on all control samples first, then:

**Docker:**
```bash
docker run --rm \
    -v /path/to/npz:/npz \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/wisecondorx:latest \
    WisecondorX newref \
        /npz/control_*.npz \
        /out/reference \
        --binsize 5000 \
        --cpus 4
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/npz:/npz \
    --bind /path/to/output:/out \
    wisecondorx.sif \
    WisecondorX newref \
        /npz/control_*.npz \
        /out/reference \
        --binsize 5000 \
        --cpus 4
```

Output: `/out/reference.npz`

### Step 3: Predict CNAs

**Docker:**
```bash
docker run --rm \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/wisecondorx:latest \
    WisecondorX predict \
        /out/sample.npz \
        /out/reference.npz \
        /out/sample_results \
        --zscore 5 \
        --bed \
        --plot
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/output:/out \
    wisecondorx.sif \
    WisecondorX predict \
        /out/sample.npz \
        /out/reference.npz \
        /out/sample_results \
        --zscore 5 \
        --bed \
        --plot
```

Results written to `/out/sample_results.*` (BED files and optional PNG plots).

### Determine sample gender

**Docker:**
```bash
docker run --rm \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/wisecondorx:latest \
    WisecondorX gender /out/sample.npz /out/reference.npz
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/output:/out \
    wisecondorx.sif \
    WisecondorX gender /out/sample.npz /out/reference.npz
```

### CRAM input (requires reference)

**Docker:**
```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/wisecondorx:latest \
    WisecondorX convert \
        /data/sample.cram \
        /out/sample.npz \
        -r /data/reference.fa
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    --bind /path/to/output:/out \
    wisecondorx.sif \
    WisecondorX convert \
        /data/sample.cram \
        /out/sample.npz \
        -r /data/reference.fa
```

## Key Arguments

### `WisecondorX convert`

| Argument | Description |
|----------|-------------|
| `infile` | BAM or CRAM input file (required) |
| `outfile` | Output NPZ file (required) |
| `--binsize INT` | Bin size in bp (default: 5000) |
| `--rmdup` | Remove duplicate reads (default: true) |
| `-r FILE` | Reference FASTA for CRAM decoding |

### `WisecondorX newref`

| Argument | Description |
|----------|-------------|
| `infiles` | Control NPZ files (glob or space-separated, required) |
| `prefix` | Output file prefix (required) |
| `--binsize INT` | Target bin size in bp (default: 5000) |
| `--refsize INT` | Reference locations per target (default: 300) |
| `--cpus INT` | Parallel cores (default: 1) |
| `--nipt` | Enable NIPT mode |

### `WisecondorX predict`

| Argument | Description |
|----------|-------------|
| `infile` | Test sample NPZ file (required) |
| `reference` | Reference NPZ file (required) |
| `outid` | Output path/prefix (required) |
| `--zscore FLOAT` | Z-score cutoff for CNA calling (default: 5.0) |
| `--alpha FLOAT` | p-value cutoff for CBS breakpoints (default: 1e-4) |
| `--blacklist FILE` | BED file of regions to mask |
| `--bed` | Write BED output files (default: true) |
| `--plot` | Write PNG plot files (requires R) |
| `--gender_override STR` | Force gender: `M` or `F` |

## Output Files

| File | Description |
|------|-------------|
| `<outid>_bins.bed` | Per-bin z-scores and copy number |
| `<outid>_segments.bed` | Segmented copy number calls |
| `<outid>_aberrations.bed` | Called CNA regions |
| `<outid>_chr*.png` | Per-chromosome plots (with `--plot`) |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| BAM/CRAM files | `/data` | Input sequencing data |
| Output directory | `/out` | NPZ files, references, results |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
