#!/bin/sh
set -eo pipefail -o nounset

wget --quiet -O grch37-sequence-1000g-v1.fa.gz ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz
bgzip -fd grch37-sequence-1000g-v1.fa.gz
samtools faidx grch37-sequence-1000g-v1.fa 
