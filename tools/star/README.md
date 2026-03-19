# STAR

STAR (Spliced Transcripts Alignment to a Reference) is an ultrafast splice-aware
aligner for RNA-seq reads. It accurately maps reads across splice junctions and
supports gene count quantification, two-pass alignment, and sorted BAM output.

## Quick Start

```bash
docker pull ghcr.io/khan-lab/star:latest
```

## Usage

STAR follows a two-step workflow:
1. **genomeGenerate** — build a genome index from a reference FASTA and GTF
2. **alignReads** — align RNA-seq reads against the index

### Step 1: Generate genome index

> Requires ≥32 GB RAM for mammal-sized genomes. The index only needs to be
> built once per reference + annotation combination.

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/genome:/genome \
    ghcr.io/khan-lab/star:latest \
    STAR \
        --runMode genomeGenerate \
        --genomeDir /genome/hg38 \
        --genomeFastaFiles /data/hg38.fa \
        --sjdbGTFfile /data/hg38.gtf \
        --sjdbOverhang 149 \
        --runThreadN 8
```

Set `--sjdbOverhang` to your read length minus 1 (e.g. 149 for 150 bp reads).

### Step 2: Align reads

#### Paired-end (gzipped FASTQ)

```bash
docker run --rm \
    -v /path/to/data:/data \
    -v /path/to/genome:/genome \
    -v /path/to/output:/out \
    ghcr.io/khan-lab/star:latest \
    STAR \
        --runMode alignReads \
        --genomeDir /genome/hg38 \
        --readFilesIn /data/R1.fq.gz /data/R2.fq.gz \
        --readFilesCommand zcat \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMattributes NH HI AS NM MD \
        --quantMode GeneCounts \
        --outFileNamePrefix /out/sample_ \
        --runThreadN 8
```

#### Single-end

```bash
STAR \
    --runMode alignReads \
    --genomeDir /genome/hg38 \
    --readFilesIn /data/reads.fq.gz \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate \
    --outFileNamePrefix /out/sample_ \
    --runThreadN 8
```

### Two-pass alignment (improved splice junction detection)

```bash
# First pass — discover novel junctions
STAR --genomeDir /genome/hg38 --readFilesIn /data/R1.fq.gz /data/R2.fq.gz \
     --readFilesCommand zcat --outSAMtype None \
     --outFileNamePrefix /out/pass1_ --runThreadN 8

# Second pass — align with novel junctions
STAR --genomeDir /genome/hg38 --readFilesIn /data/R1.fq.gz /data/R2.fq.gz \
     --readFilesCommand zcat \
     --sjdbFileChrStartEnd /out/pass1_SJ.out.tab \
     --outSAMtype BAM SortedByCoordinate \
     --outFileNamePrefix /out/pass2_ --runThreadN 8
```

Or use the built-in two-pass mode with `--twopassMode Basic`.

## Key Arguments

### `genomeGenerate`

| Argument | Description |
|----------|-------------|
| `--genomeDir DIR` | Output directory for genome index (required) |
| `--genomeFastaFiles FILE` | Reference FASTA (required) |
| `--sjdbGTFfile FILE` | GTF/GFF annotation for splice junctions |
| `--sjdbOverhang INT` | Read length − 1 (default: 100) |
| `--runThreadN INT` | Threads (default: 1) |

### `alignReads`

| Argument | Description |
|----------|-------------|
| `--genomeDir DIR` | Genome index directory (required) |
| `--readFilesIn FILE [FILE]` | FASTQ input; R1 and R2 for paired-end (required) |
| `--readFilesCommand STR` | Decompressor: `zcat` for `.gz`, `bzcat` for `.bz2` |
| `--outSAMtype STR` | Output format: `BAM SortedByCoordinate` (recommended) |
| `--quantMode STR` | `GeneCounts` for gene-level count table |
| `--outFileNamePrefix STR` | Output path prefix (required) |
| `--runThreadN INT` | Threads (default: 1) |
| `--twopassMode Basic` | Enable built-in two-pass alignment |
| `--outFilterMultimapNmax INT` | Max multi-mapping loci (default: 10) |

## Output Files

| File | Description |
|------|-------------|
| `<prefix>Aligned.sortedByCoord.out.bam` | Sorted BAM alignments |
| `<prefix>ReadsPerGene.out.tab` | Gene count table (with `--quantMode GeneCounts`) |
| `<prefix>SJ.out.tab` | Splice junction table |
| `<prefix>Log.final.out` | Alignment statistics summary |

## Mount Points

| Host Path | Container Path | Purpose |
|-----------|---------------|---------|
| Reference FASTA and FASTQs | `/data` | Input sequencing data |
| Genome index directory | `/genome` | STAR genome index |
| Output directory | `/out` | BAM files and count tables |

## Image Tags

| Tag | Description |
|-----|-------------|
| `latest` | Most recent release |
| `X.Y.Z` | Pinned release version |
| `edge` | Latest `main` branch build |
| `sha-<short>` | Specific commit build |
