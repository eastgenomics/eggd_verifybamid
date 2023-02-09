#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

dx download "$input_bam" -o "$input_bam_name"
dx download "$input_bam_index" -o "${input_bam_prefix}.bai"
dx download "$vcf_file" -o "$input_vcf_name"

# Create output directory
mkdir -p out/verifybamid_out/

# Call verifyBamID for contamination check. The following notable options are passed:
# --ignoreRG; to check the contamination for the entire BAM rather than examining individual read groups
# --precise; calculate the likelihood in log-scale for high-depth data (recommended when --maxDepth is greater than 20)
# --maxDepth 1000; For the targeted exome sequencing, --maxDepth 1000 and --precise is recommended.
verifyBamID --vcf $vcf_input_name \
     --bam $input_bam_name \
     --out out/verifybamid_out/$input_bam_prefix \
     --verbose --ignoreRG --precise --maxDepth 1000

# Upload results to DNAnexus
dx-upload-all-outputs