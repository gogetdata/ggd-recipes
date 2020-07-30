#!/bin/sh
set -eo pipefail -o nounset

wget --quiet -O - ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh37_mapping/GRCh37.primary_assembly.genome.fa.gz \
    | gzip -dc \
    | bgzip -c > hg19-reference-genome-gencode-v1.fa.gz

samtools faidx hg19-reference-genome-gencode-v1.fa.gz
