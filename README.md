# R2 Paper Viz Pipeline

## Setting up the project
We use the in-built environment manager in snakemake. Therefore it's required to have conda or compatible environment installed. As repeatmasker is currently only stable/supported for x64, we will need to install it in a seperate conda environment if we're on an Apple Silicon machine. We recommend you use `micromamba` to install the second environment.


**Install Conda Environments**
1. Install base requirements
2. Install repeatmasker manuall for x64


Install the project's base requirements:

```bash
conda env create -f envs/base_project.yaml
```

Repeatmasker is currently only tested/stable for x64, we therefore need to set the architecture for the conda environment.
We use micromamba to install repeatmasker, as it's able to resolve the depenecies properly.

```bash
conda env create -f envs/smk_repeatmasker.yaml
conda activate R2-Pipeline-Repeatmasker
micromamba install bioconda::repeatmasker --platform osx-64
```

## Run Snakemake Pipeline
1. Activate the base `R2-Pipeline` environment
2. Run Snakemake step 1

**Run Pipeline**
```bash
# Activate the project environment
conda activate R2-Pipeline
# Run the snakemake pipeline (with the specified conda environments)
snakemake --use-conda
```


**Delete all generated output**

```bash
snakemake --delete-all-output
```