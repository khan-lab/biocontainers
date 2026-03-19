#!/usr/bin/env bash
set -euo pipefail

# Wrapper for STAR inside the container.
# STAR is a two-step workflow:
#   1. genomeGenerate – build a genome index
#   2. alignReads     – align RNA-seq reads
#
# Usage: run_star.sh <genomeGenerate|alignReads> [args...]
#
# Examples:
#   run_star.sh genomeGenerate \
#       --genomeDir /genome/hg38 \
#       --genomeFastaFiles /data/hg38.fa \
#       --sjdbGTFfile /data/hg38.gtf \
#       --sjdbOverhang 149 \
#       --runThreadN 8
#
#   run_star.sh alignReads \
#       --genomeDir /genome/hg38 \
#       --readFilesIn /data/r1.fq.gz /data/r2.fq.gz \
#       --readFilesCommand zcat \
#       --outSAMtype BAM SortedByCoordinate \
#       --quantMode GeneCounts \
#       --outFileNamePrefix /out/sample_ \
#       --runThreadN 8

MODE="${1:-}"

if [[ $# -eq 0 ]]; then
    echo "Usage: run_star.sh <genomeGenerate|alignReads> [args...]"
    echo ""
    echo "STAR – Spliced Transcripts Alignment to a Reference"
    echo ""
    echo "Modes:"
    echo "  genomeGenerate  Build genome index from FASTA + GTF"
    echo "  alignReads      Align RNA-seq reads to the genome"
    echo ""
    echo "genomeGenerate required args:"
    echo "  --genomeDir DIR           Output directory for genome index"
    echo "  --genomeFastaFiles FILE   Reference FASTA"
    echo "  --sjdbGTFfile FILE        GTF annotation file"
    echo "  --sjdbOverhang INT        Read length minus 1"
    echo "  --runThreadN INT          Number of threads"
    echo ""
    echo "alignReads required args:"
    echo "  --genomeDir DIR           Genome index directory"
    echo "  --readFilesIn FILE [FILE] FASTQ input (R1 [R2])"
    echo "  --outFileNamePrefix STR   Output path/prefix"
    echo ""
    echo "See: https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf"
    exit 0
fi

shift

exec STAR --runMode "$MODE" "$@"
