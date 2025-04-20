nextflow.enable.dsl = 2

workflow {
    maf_file = file("data/tcga_paad_muc16.tsv")
    mutation_script = file("scripts/01_mutation_extraction.R")

    mutation_result = extractMutations(maf_file, mutation_script)
    saveExtractedMutations(mutation_result)
}


process saveExtractedMutations {
    input:
    path mutation_file

    output:
    path "results/"

    script:
    """
    mkdir -p results
    cp ${mutation_file} results/ca125_mutations.tsv
    """
}


process saveExtractedMutations {
    input:
    path mutation_file

    output:
    path "results/ca125_mutations.tsv"

    script:
    """
    mkdir -p results
    cp ${mutation_file} results/ca125_mutations.tsv
    """
}




process predictEpitopes {
    input:
    path mutation_file
    path epitope_script

    output:
    path "results/epitope_predictions.tsv"

    script:
    """
    mkdir -p results
    python3 ${epitope_script} ${mutation_file}
    cp epitope_predictions.tsv results/
    """
}

process filterEpitopes {
    input:
    path "epitope_predictions.tsv"

    output:
    path "filtered_epitopes.tsv"

    script:
    """
    Rscript scripts/03_filter_epitopes.R epitope_predictions.tsv
    """
}

process assembleVaccine {
    input:
    path "filtered_epitopes.tsv"

    output:
    path "vaccine_construct.fasta"

    script:
    """
    Rscript scripts/04_vaccine_assembly.R filtered_epitopes.tsv
    """
}

process simulateImmuneResponse {
    input:
    path "vaccine_construct.fasta"

    output:
    path "immunesim_output"

    script:
    """
    mkdir -p immunesim_output
    python3 scripts/05_immune_simulation.py vaccine_construct.fasta > immunesim_output/simulation.txt
    """
}

