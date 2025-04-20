#!/bin/bash -ue
mkdir -p data
wget -O data/pdac_mutations.vcf https://huggingface.co/datasets/putriimnida/vcf-test/raw/main/pdac_mutations.vcf
