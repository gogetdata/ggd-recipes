#!/bin/sh
set -eo pipefail -o nounset


wget --quiet -O hg38-sequence-1000g-v1.fa ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa 

wget --quiet -O hg38-sequence-1000g-v1.fa.fai ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.fai 

wget --quiet -O hg38-sequence-1000g-v1.dict ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.dict 




