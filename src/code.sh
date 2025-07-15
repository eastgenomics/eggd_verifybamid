#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

dx download "$input_file" -o "$input_file_name"
dx download "$input_file_index" -o "$input_file_index_name"
dx download "$vcf_file" -o "$vcf_file_name"

# if input_bam_name == cram, convert to bam and reindex
if [[ $input_file_name == *.cram ]]; then
     echo "Input is CRAM – converting to BAM"

     [[ -z ${reference_fasta:-} || -z ${reference_fasta_index:-} ]] && \
         { echo "ERROR: reference_fasta and reference_fasta_index are mandatory for CRAM input" >&2; exit 1; }

     dx download "$reference_fasta" -o "$reference_fasta_name"
     dx download "$reference_fasta_index" -o "$reference_fasta_index_name"
     samtools view -b -T "$reference_fasta_name" -o "$input_file_prefix".bam "$input_file_name"
     samtools index "$input_file_prefix".bam

fi

# Create output directory
mkdir -p out/verifybamid_out/

# Call verifyBamID for contamination check. The following notable options are passed:
# --ignoreRG; to check the contamination for the entire BAM rather than examining individual read groups
# --precise; calculate the likelihood in log-scale for high-depth data (recommended when --maxDepth is greater than 20)
# --maxDepth 1000; For the targeted exome sequencing, --maxDepth 1000 and --precise is recommended.
verifyBamID --vcf $vcf_file_name \
     --bam $input_file_prefix.bam \
     --out out/verifybamid_out/$input_file_prefix \
     --verbose --ignoreRG --precise --maxDepth 1000

# Upload results to DNAnexus
dx-upload-all-outputs