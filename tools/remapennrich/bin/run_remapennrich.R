#!/usr/bin/env Rscript
# run_remapennrich.R — CLI wrapper for the ReMapEnrich R package
#
# Usage:
#   docker run --rm \
#     -v /path/to/beds:/data:ro \
#     -v /path/to/results:/out \
#     ghcr.io/khan-lab/remapennrich:latest \
#     Rscript /usr/local/bin/run_remapennrich.R \
#       --bed /data/regions.bed --genome hg38 --out /out/enrichment.tsv
suppressPackageStartupMessages(library(optparse))

option_list <- list(
  make_option(c("--bed"),    type = "character", default = NULL,
              help = "Input BED file of query genomic regions [required]"),
  make_option(c("--genome"), type = "character", default = "hg38",
              help = "Genome assembly: hg38, hg19, mm10, dm6, ce11, rn5 [default: %default]"),
  make_option(c("--catalog"), type = "character", default = NULL,
              help = "Custom catalog BED file (skips ReMap download if provided)"),
  make_option(c("--pval"),   type = "double",    default = 0.05,
              help = "p-value significance cutoff for output [default: %default]"),
  make_option(c("--out"),    type = "character", default = "/out/enrichment.tsv",
              help = "Output TSV file path [default: %default]")
)

opt <- parse_args(OptionParser(
  option_list = option_list,
  description = "ReMapEnrich: enrichment analysis against the ReMap TF binding catalog",
  epilogue    = "Catalog (~500 MB) is downloaded from ReMap servers when --catalog is omitted."
))

if (is.null(opt$bed)) {
  message("Error: --bed is required. Run with --help for usage.")
  quit(status = 1)
}

suppressPackageStartupMessages({
  library(ReMapEnrich)
  library(GenomicRanges)
})

message("Loading query regions from: ", opt$bed)
query <- bedToGranges(opt$bed)

if (!is.null(opt$catalog)) {
  message("Loading custom catalog from: ", opt$catalog)
  catalog <- bedToGranges(opt$catalog)
} else {
  message("Downloading ReMap catalog for genome: ", opt$genome)
  catalog <- downloadRemapCatalog(opt$genome)
}

message("Running enrichment analysis...")
result <- enrichment(query, catalog)

result <- result[result$pvalue < opt$pval, ]
message(nrow(result), " significant hits (p < ", opt$pval, ")")

dir.create(dirname(opt$out), showWarnings = FALSE, recursive = TRUE)
write.table(result, opt$out, sep = "\t", quote = FALSE, row.names = FALSE)
message("Results written to: ", opt$out)
