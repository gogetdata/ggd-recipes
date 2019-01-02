#!/bin/sh
set -eo pipefail -o nounset
# get reference file from 1000 genomes ftp site
wget --quiet http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz

# unzip the reference
bgzip -fd hs37d5.fa.gz 

# index the reference
samtools faidx hs37d5.fa
