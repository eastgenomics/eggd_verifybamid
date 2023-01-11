# eggd_verifybamid

eggd_ verifybamid is based on statgen/verifyBamID [v1.1.3] (tested with https://github.com/ewels/MultiQC/releases/tag/v1.3) made for use by the bioinformatics team at Addenbrookes for accessing contamination in genomic samples.

## What does this app do?
This app runs verifyBamID to detect sample contamination from population allele frequencies.

verifyBamID models the sequence reads as mixture of two unknown samples based on the allele frequency information in a provided VCF file; the VCF is packaged with the app under resources/home/dnanexus. # is this causing problems for me building the app?
See (https://genome.sph.umich.edu/wiki/VerifyBamID) for further details.

## What are typical use cases for this app?
This app should be executed stand-alone or as part of a DNAnexus workflow for a single sample.

## What data are required for this app to run?
The app requires a BAM file (.bam) and a corresponding index file (.bai) to run.

## What does this app output?
The app outputs three files, where [outPrefix] is the bam filename without extension:
1. [outPrefix].selfSM - Per-sample statistics describing how well the sample matches to the annotated sample (tab-delimited file)
2. [outPrefix].depthSM - The depth distribution of the sequence reads per sample (tab-delimited file)
3. [outPrefix].log - verifyBamID log file

The column **freeMix** in the [outPrefix].selfSM file contains the % contamination predicted for the sample (where 0.1=10%).

## How does this app work?
The app runs verifyBamID using an input BAM file and uploads the outputs to DNAnexus.

## What are the limitations of this app
- This app is only known to work on exome-like samples, as opposed to small panels.
- verifyBamID will only assess autosomal chromosomes in the input VCF.

### This app was made by EMEE GLH, and is forked from an app made by Viapath
(https://github.com/moka-guys/dnanexus_verifybamid/releases/tag/v1.1.1)
src/code.sh was updated to reflect that of (https://github.com/moka-guys/dnanexus_verifybamid/releases/tag/v1.1.1) # update
