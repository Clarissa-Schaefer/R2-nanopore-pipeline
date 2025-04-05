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
1. Download fastq file `dorado_sup.fastq` available at SRA under BioProject PRJNA1163071. 
2. Create directory `00-Data`, create subfolders `raw`, `feature_annotated` and `filtered_aligned`
3. Move `references` directory to `00-Data` and place `dorado_sup.fastq` into `raw`. 

Your `00-Data` directory should look like this: 

``` 
─ 00-Data
│   ├── feature_annotated
│   ├── filtered_aligned
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

Open the Jupyter Notebooks and run notebooks 01 through 05 sequentially. All output files and plots will be generated automatically.

## Demo 
To test the code, move the sample FASTQ file named `sample_file.fastq` from the `examples` directory to the `raw` directory and rename it to `dorado_sup.fastq`. Then, run Snakemake and execute the Jupyter Notebooks. If you later want to run the pipeline with the full dataset, make sure to delete all generated files and the FASTQ file (note: both FASTQ files currently share the same name). 

## Reproducibility Notes 
The Snakemake command was tested on a computer running Ubuntu 24.04.1 LTS with the 6.8.0-50-generic kernel, while the rest of the processing pipeline was executed locally on a macOS Sonoma 14.7.4 machine. The file `__env_export.yml` is an export of the environment used during data analysis.