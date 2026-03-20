# GRIDSS

GRIDSS (Genomic Rearrangement IDentification Software Suite) detects structural
variants including translocations, inversions, duplications, and indels from
paired-end whole-genome sequencing data. It uses local assembly to resolve
breakpoints at single-nucleotide resolution.

## Quick Start

**Docker:**
```bash
docker pull ghcr.io/khan-lab/gridss:latest
```

**Singularity:**
```bash
singularity pull gridss.sif docker://ghcr.io/khan-lab/gridss:latest
```

## Prerequisites

GRIDSS requires a **BWA-indexed reference genome** at runtime. Build the index
before running (or mount a pre-indexed reference):

```bash
# Index the reference (run once, outside the container or via another image)
bwa index /path/to/reference.fa
samtools faidx /path/to/reference.fa
```

## Usage

The `gridss` command is on `PATH` and wraps `java -jar gridss.jar`.

### Somatic calling (tumor + normal)

**Docker:**
```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/gridss:latest \
    gridss \
        --reference /data/reference.fa \
        --output /out/somatic.vcf.gz \
        -t /data/tumor.bam \
        -n /data/normal.bam \
        --threads 8
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    --bind /path/to/output:/out \
    gridss.sif \
    gridss \
        --reference /data/reference.fa \
        --output /out/somatic.vcf.gz \
        -t /data/tumor.bam \
        -n /data/normal.bam \
        --threads 8
```

### Germline calling (single sample)

**Docker:**
```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/gridss:latest \
    gridss \
        --reference /data/reference.fa \
        --output /out/germline.vcf.gz \
        /data/sample.bam \
        --threads 8
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    --bind /path/to/output:/out \
    gridss.sif \
    gridss \
        --reference /data/reference.fa \
        --output /out/germline.vcf.gz \
        /data/sample.bam \
        --threads 8
```

### Adjusting Java heap size

**Docker:**
```bash
docker run --rm \
    -e GRIDSS_JAVA_MEM=32g \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/gridss:latest \
    gridss --reference /data/reference.fa --output /out/output.vcf.gz /data/sample.bam
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    --bind /path/to/output:/out \
    gridss.sif \
    gridss --reference /data/reference.fa --output /out/output.vcf.gz /data/sample.bam
```

## Key Arguments

| Argument | Description |
|----------|-------------|
| `--reference FILE` | BWA-indexed reference genome FASTA (required) |
| `--output FILE` | Output VCF or VCF.gz file (required) |
| `-t FILE` | Tumor BAM for somatic calling |
| `-n FILE` | Matched normal BAM for somatic calling |
| `--threads INT` | Number of worker threads (default: 8) |
| `--workingdir DIR` | Scratch directory for temporary files |
| `--jvmheap SIZE` | Java heap size (overrides `GRIDSS_JAVA_MEM`) |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `GRIDSS_JAVA_MEM` | `16g` | Java heap size passed to `-Xmx` |
| `GRIDSS_JAR` | `/opt/gridss/gridss.jar` | Path to GRIDSS JAR |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| Reference genome + BAM files | `/data` | Input data |
| Output directory | `/out` | VCF results and working files |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
