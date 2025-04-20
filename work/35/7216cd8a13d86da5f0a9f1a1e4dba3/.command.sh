#!/bin/bash -ue
mkdir -p results
Rscript 01_mutation_extraction.R tcga_paad_muc16.tsv
cp ca125_mutations.tsv results/
