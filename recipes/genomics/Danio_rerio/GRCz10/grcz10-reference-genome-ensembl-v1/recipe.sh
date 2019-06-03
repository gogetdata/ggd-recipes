#!/bin/sh
set -eo pipefail -o nounset

## Get the GRCz10 reference genome release 91 from Ensembl
wget --quiet -O grcz10-reference-genome-ensembl-v1.fa.gz ftp://ftp.ensembl.org/pub/release-91/fasta/danio_rerio/dna/Danio_rerio.GRCz10.dna.toplevel.fa.gz

## Unzip the file using GNU zip
gzip -fd grcz10-reference-genome-ensembl-v1.fa.gz

## Index the reference genome
samtools faidx grcz10-reference-genome-ensembl-v1.fa 
