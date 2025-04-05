# R2 Paper Viz Pipeline

## Setting up the project
We use the in-built environment manager in snakemake. Therefore it's required to have conda or compatible environment installed. As repeatmasker is currently only stable/supported for x64, we will need to install it in a seperate conda environment if we're on an Apple Silicon machine. We recommend you use `micromamba` to install the second environment. The installation of both environments should take less than ten minutes. 


### Install Conda Environments
1. Install base requirements
2. Install repeatmasker via file or manually for AARCH64 (Apple Silicon) 

**Install the project's base requirements:**

```bash
conda env create -f envs/base_project.yaml
```

**Install repeatmasker:**

_Windows/Linux/MacOS x64 only_
```bash
# The next step will fail on MacOS AARCH64 (Apple Silicon)
conda env create -f envs/smk_repeatmasker.yaml
```

_MacOS Apple Silicon only_

Repeatmasker is currently only tested/stable for x64, for Apple Silicon we therefore need to set the architecture to x64 and use Rosetta for the conda environment.
We use micromamba to install repeatmasker, as it's able to resolve the depenecies properly.

```bash
conda create --name R2-Pipeline-Repeatmasker
conda activate R2-Pipeline-Repeatmasker
micromamba install bioconda::repeatmasker --platform osx-64
```
## Download data and create data folder 
1. Download fastq file accessible on NCBI (accession code see...).
2. Create Folder `00-Data`, create subfolder `raw`
3. move `references` folder to `00-Data` and place `dorado_sup.fastq` into `raw`. 

Your `00-Data` folder should look like this: 

``` 
─ 00-Data
│   ├── raw
│   │   └── dorado_sup.fastq
│   ├── references
│   │   ├── ref_28s_features.fasta
│   │   ├── ref_400nt_flanking_Transgene.fasta
│   │   ├── ref_crRNA_Transgene.fasta
│   │   └── ref_crRNA_no_insert.fasta

```
    
## Run Pipeline
1. Activate the base `R2-Pipeline` environment
2. Run Snakemake (see below)

**Run Snakemake Pipeline**
```bash
# Activate the project environment
conda activate R2-Pipeline
# Run the snakemake pipeline (with the specified conda environments)
snakemake --use-conda
```

**Run ipynb 01 to 05**
open the jupyter notebooks and run notebook 1 to 5 subsequentially. Output files and plots should be created automatically. 

## Demo 


## Reproducibility Notes 

The snakemake command was tested on a computer running Ubuntu 24.04.1 LTS, 6.8.0-50-generic kernel. The remaining processing pipeline was executed locally on a machine running macOS Sonoma 14.7.4. The file `__env_export.yml` is an export of our environment used during the data analysis. 