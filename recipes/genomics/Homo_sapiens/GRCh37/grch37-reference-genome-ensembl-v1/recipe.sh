#!/bin/sh
set -eo pipefail -o nounset

## Get the GRCh37 reference genome release 75. This is the primary assembly file
wget --quiet -O grch37-reference-genome-ensembl-v1.fa.gz ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz

## Unzip the file using GNU zip. (All files are compacted with GNU Zip for storage efficiency.) (ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/README)
gzip -fd grch37-reference-genome-ensembl-v1.fa.gz

## Index the reference genome using samtools
samtools faidx grch37-reference-genome-ensembl-v1.fa
