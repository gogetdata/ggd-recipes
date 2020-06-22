#!/bin/sh
set -eo pipefail -o nounset

## Get the GRCh38 Reference Genome release 99. This is the primary assembly file
wget --quiet -O grch38-reference-genome-ensembl-v1.fa.gz ftp://ftp.ensembl.org/pub/release-99/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

## Unzip the file using GNU zip. (All files are compacted with GNU Zip for storage efficiency.) (ftp://ftp.ensembl.org/pub/release-95/fasta/homo_sapiens/dna/README)
gzip -fd grch38-reference-genome-ensembl-v1.fa.gz

## Index the reference genome using samtools
samtools faidx grch38-reference-genome-ensembl-v1.fa 
