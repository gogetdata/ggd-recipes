#!/bin/sh
set -eo pipefail -o nounset

## Get the GRCh38 Reference Genome release 99. This is the primary assembly file
wget --quiet -O - ftp://ftp.ensembl.org/pub/release-99/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.toplevel.fa.gz \
    | gzip -dc  \
    | bgzip -c > grch38-toplevel-reference-genome-ensembl-v1.fa.gz

## Index the reference genome using samtools
samtools faidx grch38-toplevel-reference-genome-ensembl-v1.fa.gz 
