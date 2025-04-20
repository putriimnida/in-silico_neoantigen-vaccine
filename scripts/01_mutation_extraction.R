# 01_mutation_extraction.R

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]

# Read filtered MUC16 mutation file from TCGA-PAAD
muc16 <- read.delim(input_file, stringsAsFactors = FALSE)

# Keep only key columns and rename if needed
mutations <- data.frame(
  CHROM = muc16$Chromosome,
  POS = muc16$Start_Position,
  REF = muc16$Reference_Allele,
  ALT = muc16$Tumor_Seq_Allele2,
  GENE = muc16$Hugo_Symbol,
  TYPE = muc16$Variant_Classification
)

# Create a mutation ID column
mutations$mutation_id <- paste0(mutations$GENE, "_", mutations$POS, "_", mutations$REF, ">", mutations$ALT)

# Write result for next step
write.table(mutations, file = "ca125_mutations.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
