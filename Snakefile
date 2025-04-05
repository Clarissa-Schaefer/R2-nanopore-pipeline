################################################################################
### Snakemake Pipeline to Align Samples and Annotate Features (RepeatMasker) ###
################################################################################


# -----------------------------------------------------------------------------#
#                             Configure Pipeline                               #
# -----------------------------------------------------------------------------#

# Specify the names for the references ref_<REFERENCE>.fasta
REFERENCES = ["crRNA_Transgene", "crRNA_no_insert"]


# -----------------------------------------------------------------------------#
#                               Helper Scripts                                 #
# -----------------------------------------------------------------------------#
import platform
import shutil

# Determine what the RepeatMasker command is based on OS
def get_repeatmasker_cmd():
    system = platform.system().lower()
    if system == "darwin":  # macOS
        return "RepeatMasker" if shutil.which("RepeatMasker") else "repeatmasker"
    else:  # Linux, Windows, etc
        return "RepeatMasker"


# -----------------------------------------------------------------------------#
#                             Pipeline Entry Points                            #
# -----------------------------------------------------------------------------#

# Specify the base entry point
rule all:
    input:
        "00-Data/repeatmaskered/sample-cutadapt_sup-filtered.fasta.out.xm"

# rule step_2:
#     input:
#         "00-Data/mapped_reads/mm2-filtered_sup-crRNA_Transgene.sam"


# -----------------------------------------------------------------------------#
#                               Pipeline Rules                                 #
# -----------------------------------------------------------------------------#

# Run Cutadapt (trimming)
rule cutadapt:
    input:
        "00-Data/raw/dorado_sup.fastq"
    output:
        "00-Data/samples/sample-cutadapt_sup.fastq"
    shell:
        "cutadapt --trim-n -q 20 -m 20 -o {output} {input}"

# Run alignment
rule mm2_map:
    input:
        reference="00-Data/references/ref_{reference}.fasta",
        sample="00-Data/samples/sample-{sample_name}.fastq"
    output:
        "00-Data/mapped_reads/mm2-{sample_name}-{reference}.sam"
    shell:
        "minimap2 -a --splice --MD --eqx {input.reference} {input.sample} | samtools view -h -F 4 -o {output}"

# Calculate unique IDs
rule calc_uniqe_ids:
    input:
        "00-Data/mapped_reads/mm2-{sample_name}-{reference}.sam"
    output:
        "00-Data/unique_ids/unique_ids-{sample_name}-{reference}.txt"
    shell:
        "grep -v '^@' {input} | cut -f1 | sort | uniq > {output}"

# Concatenate the two lists, make unique, filter the FASTQ file
rule filter_reads:
    input:
        id_list=expand("00-Data/unique_ids/unique_ids-cutadapt_sup-{reference}.txt", reference=REFERENCES),
        sample="00-Data/samples/sample-{sample_name}.fastq"
    output:
        "00-Data/samples_filtered/sample-{sample_name}-filtered.fastq"
    shell:
        "cat {input.id_list} | sort | uniq | seqtk subseq {input.sample} - > {output}"

# Convert FASTQ to FASTA
rule fastq_to_fasta:
    input:
        "{input_dir}/{seq_name}.fastq"
    output:
        "{input_dir}/{seq_name}.fasta"
    shell:
        "seqtk seq -A {input} > {output}"

# Run RepeatMasker
rule repeatmasker:
    input:
        library="00-Data/references/ref_28s_features.fasta",
        sample="00-Data/samples_filtered/sample-cutadapt_sup-filtered.fasta"
    output:
        dir="00-Data/repeatmaskered/",
        dummy_out="00-Data/repeatmaskered/sample-cutadapt_sup-filtered.fasta.out",
        dummy_out_xm="00-Data/repeatmaskered/sample-cutadapt_sup-filtered.fasta.out.xm"
    params:
        cmd=get_repeatmasker_cmd()
    conda:
        "R2-Pipeline-Repeatmasker"
    resources:
        repeatmasker=1
    shell:
        "{params.cmd} -dir {output.dir} -e ncbi -pa 36 -q -no_is -nolow -norna -div 40 -lib {input.library} {input.sample} -xm"