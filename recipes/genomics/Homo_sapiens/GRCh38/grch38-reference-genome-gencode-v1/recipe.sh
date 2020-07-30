#!/bin/sh
set -eo pipefail -o nounset

wget --quiet -O - ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh38.p13.genome.fa.gz\
    | gzip -dc \
    | sed "s/chrM/MT/g" \
    | sed "s/chr//g" \
    | bgzip -c > grch38-reference-genome-gencode-v1.fa.gz

samtools faidx grch38-reference-genome-gencode-v1.fa.gz
