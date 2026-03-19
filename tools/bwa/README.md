# BWA

BWA (Burrows-Wheeler Aligner) is a fast, memory-efficient aligner for short DNA
reads against a large reference genome. `bwa mem` is the recommended algorithm
for reads ≥70 bp and supports paired-end alignment, split/chimeric reads, and
read group tagging.

## Quick Start

**Docker:**
```bash
docker pull ghcr.io/khan-lab/bwa:latest
```

**Singularity:**
```bash
singularity pull bwa.sif docker://ghcr.io/khan-lab/bwa:latest
```

## Usage

BWA requires two steps: index the reference, then align reads.

### Step 1: Index the reference

**Docker:**
```bash
docker run --rm \
    -v /path/to/data:/data \
    ghcr.io/khan-lab/bwa:latest \
    bwa index /data/reference.fa
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    bwa.sif \
    bwa index /data/reference.fa
```

Index files (`.amb`, `.ann`, `.bwt`, `.pac`, `.sa`) are written alongside the
reference FASTA.

### Step 2: Align reads

#### Paired-end

**Docker:**
```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/bwa:latest \
    bwa mem \
        -t 8 \
        -R "@RG\tID:sample\tSM:sample\tPL:ILLUMINA" \
        /data/reference.fa \
        /data/read1.fq.gz \
        /data/read2.fq.gz \
        | samtools sort -@ 4 -o /out/aligned.bam && \
    samtools index /out/aligned.bam
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    --bind /path/to/output:/out \
    bwa.sif \
    bwa mem \
        -t 8 \
        -R "@RG\tID:sample\tSM:sample\tPL:ILLUMINA" \
        /data/reference.fa \
        /data/read1.fq.gz \
        /data/read2.fq.gz \
        | samtools sort -@ 4 -o /out/aligned.bam && \
    samtools index /out/aligned.bam
```

#### Single-end

**Docker:**
```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/bwa:latest \
    bwa mem \
        -t 8 \
        /data/reference.fa \
        /data/reads.fq.gz \
        | samtools sort -o /out/aligned.bam
```

**Singularity:**
```bash
singularity exec \
    --bind /path/to/data:/data \
    --bind /path/to/output:/out \
    bwa.sif \
    bwa mem \
        -t 8 \
        /data/reference.fa \
        /data/reads.fq.gz \
        | samtools sort -o /out/aligned.bam
```

### GATK / Picard compatibility

Add `-M` to flag supplementary alignments as secondary (required by some GATK tools):

```bash
bwa mem -M -R "@RG\tID:id\tSM:sample\tPL:ILLUMINA" \
    /data/reference.fa /data/r1.fq.gz /data/r2.fq.gz \
    | samtools sort -o /out/aligned.bam
```

## Key Arguments (`bwa mem`)

| Argument | Description |
|----------|-------------|
| `-t INT` | Number of threads (default: 1) |
| `-R STR` | Read group header line (`@RG\tID:...\tSM:...`) |
| `-M` | Mark split hits as secondary (Picard/GATK compatible) |
| `-k INT` | Minimum seed length (default: 19) |
| `-A INT` | Match score (default: 1) |
| `-B INT` | Mismatch penalty (default: 4) |
| `-O INT` | Gap open penalty (default: 6) |
| `-E INT` | Gap extension penalty (default: 1) |

## Key Arguments (`bwa index`)

| Argument | Description |
|----------|-------------|
| `ref.fa` | Reference FASTA to index (required) |
| `-a STR` | Algorithm: `is` (default, <2 GB), `bwtsw` (large genomes) |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| Reference FASTA and FASTQs | `/data` | Input files |
| Output directory | `/out` | Aligned BAM files |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
