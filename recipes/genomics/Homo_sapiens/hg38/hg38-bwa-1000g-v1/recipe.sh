#!/bin/sh
set -eo pipefail -o nounset

wget --quiet -O hg38-bwa-1000g-v1.fa.bwt ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.bwt

wget --quiet -O hg38-bwa-1000g-v1.fa.amb ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.amb

wget --quiet -O hg38-bwa-1000g-v1.fa.ann ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.ann

wget --quiet -O hg38-bwa-1000g-v1.fa.pac ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.pac

wget --quiet -O hg38-bwa-1000g-v1.fa.sa ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.sa

wget --quiet -O hg38-bwa-1000g-v1.fa.alt ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt
