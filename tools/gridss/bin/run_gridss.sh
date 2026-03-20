#!/usr/bin/env bash
set -euo pipefail

# Wrapper for GRIDSS inside the container.
# Runs the GRIDSS JAR via Java with sensible defaults.
#
# Usage: gridss [args...]
#
# Examples:
#   gridss --reference /data/ref.fa --output /out/output.vcf.gz /data/tumor.bam
#   gridss --reference /data/ref.fa --output /out/output.vcf.gz \
#       -t /data/tumor.bam -n /data/normal.bam

GRIDSS_JAR="${GRIDSS_JAR:-/opt/gridss/gridss.jar}"
JAVA_MEM="${GRIDSS_JAVA_MEM:-16g}"

if [[ $# -eq 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "Usage: gridss [args...]"
    echo ""
    echo "GRIDSS – structural variant detection from WGS data"
    echo ""
    echo "Required arguments:"
    echo "  --reference FILE    Reference genome FASTA (must be BWA-indexed)"
    echo "  --output FILE       Output VCF or VCF.gz file"
    echo "  FILE.bam ...        One or more input BAM files"
    echo ""
    echo "Optional arguments:"
    echo "  -t FILE             Tumor BAM (for somatic calling)"
    echo "  -n FILE             Normal BAM (for somatic calling)"
    echo "  --threads INT       Number of threads (default: 8)"
    echo "  --workingdir DIR    Scratch directory (default: .)"
    echo ""
    echo "Environment:"
    echo "  GRIDSS_JAVA_MEM     Java heap size (default: 16g)"
    echo ""
    echo "See: https://github.com/Illumina/GRIDSS"
    exec java -jar "${GRIDSS_JAR}" --help 2>&1 || true
    exit 0
fi

exec java -Xmx${JAVA_MEM} -jar "${GRIDSS_JAR}" "$@"
