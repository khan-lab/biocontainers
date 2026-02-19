#!/usr/bin/env Rscript

# =============================================================================
# run_rgreat.R
# Genomic region enrichment analysis using rGREAT (local GREAT algorithm).
#
# Usage:
#   Rscript run_rgreat.R --bed regions.bed --genome hg38 --outdir /out
# =============================================================================

suppressPackageStartupMessages({
    library(optparse)
    library(rGREAT)
    library(rtracklayer)
})

# -- Parse arguments -----------------------------------------------------------

option_list <- list(
    make_option("--bed",        type = "character", default = NULL,
                help = "Path to input BED file with genomic regions (required)"),
    make_option("--genome",     type = "character", default = "hg38",
                help = "Reference genome: hg19 or hg38 [default: %default]"),
    make_option("--collection", type = "character", default = "GO:BP, GO:MF, GO:CC",
                help = "Gene set collection, e.g. GO:BP, GO:MF, GO:CC, MSigDB:H [default: %default]"),
    make_option("--outdir",     type = "character", default = "/out",
                help = "Output directory [default: %default]"),
    make_option("--prefix",     type = "character", default = "GREAT",
                help = "Prefix for output files [default: %default]")
)

opt <- parse_args(OptionParser(option_list = option_list))

if (is.null(opt$bed)) {
    stop("--bed is required. Run with --help for usage.")
}

if (!file.exists(opt$bed)) {
    stop(paste0("BED file not found: ", opt$bed))
}

dir.create(opt$outdir, recursive = TRUE, showWarnings = FALSE)

cat("=== rGREAT Enrichment Pipeline ===\n")
cat("BED:        ", opt$bed,        "\n")
cat("Genome:     ", opt$genome,     "\n")
cat("Collection: ", opt$collection, "\n")
cat("Outdir:     ", opt$outdir,     "\n\n")

# -- Step 1: Import genomic regions --------------------------------------------
cat(">> Importing genomic regions ...\n")
gr <- import(opt$bed)
cat("   Loaded", length(gr), "regions\n")

# -- Step 2: Run local GREAT enrichment ----------------------------------------
cat(">> Running GREAT enrichment (", opt$collection, ") ...\n")
res <- great(gr, opt$collection, opt$genome)

# -- Step 3: Extract enrichment table ------------------------------------------
cat(">> Extracting enrichment table ...\n")
tb <- getEnrichmentTable(res)
cat("   Found", nrow(tb), "terms\n")

outfile <- file.path(opt$outdir, paste0(opt$prefix, "_great_enrichment.tsv"))
write.table(tb, file = outfile, sep = "\t", row.names = FALSE, quote = FALSE)
cat("   Saved to", outfile, "\n")

# -- Step 4: Volcano plot ------------------------------------------------------
cat(">> Generating volcano plot ...\n")
plotfile <- file.path(opt$outdir, paste0(opt$prefix, "_great_volcano.pdf"))

pdf(plotfile, width = 10, height = 7)
tryCatch({
    if ("fold_enrichment" %in% colnames(tb) && "p_adjust" %in% colnames(tb)) {
        plot(log2(tb$fold_enrichment), -log10(tb$p_adjust),
             xlab = "log2(Fold Enrichment)",
             ylab = "-log10(Adjusted p-value)",
             main = paste("rGREAT:", opt$collection, "(", opt$genome, ")"),
             pch = 20, col = ifelse(tb$p_adjust < 0.05, "red", "grey60"))
        abline(h = -log10(0.05), lty = 2, col = "blue")
        legend("topright", legend = c("Significant (FDR < 0.05)", "Not significant"),
               col = c("red", "grey60"), pch = 20)
    } else {
        # Fallback: try the built-in plot method
        plot(res)
    }
}, error = function(e) {
    cat("   Warning: could not generate volcano plot —", conditionMessage(e), "\n")
    plot.new()
    text(0.5, 0.5, paste("Plot generation failed:\n", conditionMessage(e)),
         cex = 0.8)
})
dev.off()
cat("   Saved to", plotfile, "\n")

cat("\n=== Done ===\n")
