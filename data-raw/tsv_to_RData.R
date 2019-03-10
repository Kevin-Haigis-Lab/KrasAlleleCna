
# Turns a tsv into a RData file

library(readr)

tcga_sample_sheet <- read_tsv("tcga_sample_sheet.tsv")
save(tcga_sample_sheet, file = "../data/tcga_sample_sheet.RData")

tcga_manifest <- read_tsv("tcga_manifest.tsv")
save(tcga_manifest, file = "../data/tcga_manifest.RData")