#!/bin/sh
set -eo pipefail -o nounset

## Get the GRCh37 reference genome release 75. This is the primary assembly file
wget --quiet -O -  ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.toplevel.fa.gz \
    | gzip -dc \
    | bgzip -c > grch37-reference-genome-ensembl-v1.fa.gz 

## Index the reference genome using samtools
samtools faidx grch37-reference-genome-ensembl-v1.fa.gz
