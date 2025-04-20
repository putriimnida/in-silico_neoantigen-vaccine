# download_maf_tcgabiolinks.R

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("TCGAbiolinks")


library(TCGAbiolinks)
library(dplyr)

# Step 1: Query TCGA-PAAD mutations
query <- GDCquery(
  project = "TCGA-PAAD",
  data.category = "Simple Nucleotide Variation",
  data.type = "Masked Somatic Mutation",
  workflow.type = "Aliquot Ensemble Somatic Variant Merging and Masking"

)

# Step 2: Download + Prepare
GDCdownload(query)
maf <- GDCprepare(query)

# Step 3: Filter for MUC16 missense mutations
muc16 <- maf %>%
  filter(Hugo_Symbol == "MUC16" & Variant_Classification == "Missense_Mutation")

# Step 4: Export to TSV
dir.create("data", showWarnings = FALSE)
write.table(muc16, file = "tcga_paad_muc16.tsv", sep = "\t", row.names = FALSE, quote = FALSE)
