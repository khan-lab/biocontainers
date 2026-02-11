#!/usr/bin/env Rscript

# =============================================================================
# run_qdnaseq.R
# Shallow WGS CNV calling pipeline using QDNAseq.
#
# Usage:
#   Rscript run_qdnaseq.R --bam sample.bam --genome hg19 --binSize 15 --outdir /out
# =============================================================================

suppressPackageStartupMessages({
    library(optparse)
    library(QDNAseq)
})

# -- Parse arguments -----------------------------------------------------------

option_list <- list(
    make_option("--bam",     type = "character", default = NULL,
                help = "Path to input BAM file (required)"),
    make_option("--genome",  type = "character", default = "hg19",
                help = "Reference genome: hg19 or hg38 [default: %default]"),
    make_option("--binSize", type = "integer",   default = 15L,
                help = "Bin size in kbp [default: %default]"),
    make_option("--outdir",  type = "character", default = "/out",
                help = "Output directory [default: %default]")
)

opt <- parse_args(OptionParser(option_list = option_list))

if (is.null(opt$bam)) {
    stop("--bam is required. Run with --help for usage.")
}

if (!file.exists(opt$bam)) {
    stop(paste0("BAM file not found: ", opt$bam))
}

dir.create(opt$outdir, recursive = TRUE, showWarnings = FALSE)

cat("=== QDNAseq Pipeline ===\n")
cat("BAM:      ", opt$bam,     "\n")
cat("Genome:   ", opt$genome,  "\n")
cat("Bin size: ", opt$binSize, "kbp\n")
cat("Outdir:   ", opt$outdir,  "\n\n")

# -- Step 1: Get bin annotations -----------------------------------------------
cat(">> Loading bin annotations ...\n")

# TODO: For hg38, install QDNAseq.hg38 or supply custom bin annotations.
#       Currently only hg19 annotations ship with QDNAseq.hg19 on Bioconductor.
if (opt$genome == "hg19") {
    bins <- getBinAnnotations(binSize = opt$binSize, genome = "hg19")
} else if (opt$genome == "hg38") {
    # Attempt hg38 – will work if QDNAseq.hg38 is installed
    bins <- tryCatch(
        getBinAnnotations(binSize = opt$binSize, genome = "hg38"),
        error = function(e) {
            stop("hg38 bin annotations not available. Install QDNAseq.hg38 or provide custom bins.")
        }
    )
} else {
    stop(paste0("Unsupported genome: ", opt$genome))
}

# -- Step 2: Bin read counts ---------------------------------------------------
cat(">> Binning reads ...\n")
readCounts <- binReadCounts(bins, bamfiles = opt$bam)

saveRDS(readCounts, file = file.path(opt$outdir, "counts_raw.rds"))
cat("   Saved raw counts to counts_raw.rds\n")

# -- Step 3: Apply filters & corrections ----------------------------------------
cat(">> Applying filters and corrections ...\n")

readCountsFiltered <- applyFilters(readCounts,
                                   residual = TRUE,
                                   blacklist = TRUE)
readCountsCorrected <- estimateCorrection(readCountsFiltered)
readCountsCorrected <- correctBins(readCountsCorrected)
readCountsCorrected <- normalizeBins(readCountsCorrected)
readCountsCorrected <- smoothOutlierBins(readCountsCorrected)

saveRDS(readCountsCorrected, file = file.path(opt$outdir, "counts_corrected.rds"))
cat("   Saved corrected counts to counts_corrected.rds\n")

# -- Step 4: Segmentation (CBS via DNAcopy) ------------------------------------
cat(">> Segmenting ...\n")
readCountsSegmented <- segmentBins(readCountsCorrected, transformFun = "sqrt")
readCountsSegmented <- normalizeSegmentedBins(readCountsSegmented)

saveRDS(readCountsSegmented, file = file.path(opt$outdir, "segments.rds"))

# Export segments as TSV
segTable <- tryCatch({
    cna <- readCountsSegmented@assayData$calls
    # Fallback: export segmented values
    seg <- as.data.frame(readCountsSegmented@assayData$segmented)
    seg$chr <- readCountsSegmented@featureData@data$chromosome
    seg$start <- readCountsSegmented@featureData@data$start
    seg$end <- readCountsSegmented@featureData@data$end
    seg
}, error = function(e) {
    cat("   Warning: could not extract segment table —", conditionMessage(e), "\n")
    NULL
})

if (!is.null(segTable)) {
    write.table(segTable,
                file = file.path(opt$outdir, "segments.tsv"),
                sep = "\t", row.names = FALSE, quote = FALSE)
    cat("   Saved segments to segments.tsv\n")
}

# -- Step 5: QC Plot -----------------------------------------------------------
cat(">> Generating CNV plot ...\n")
pdf(file.path(opt$outdir, "cnv_plot.pdf"), width = 12, height = 6)
plot(readCountsSegmented)
dev.off()
cat("   Saved plot to cnv_plot.pdf\n")

cat("\n=== Done ===\n")
