#!/bin/sh
set -eo pipefail -o nounset
set -eo pipefail -o nounset

wget --quiet -O - ftp://ftp.ensembl.org/pub/release-91/fasta/danio_rerio/dna/Danio_rerio.GRCz10.dna.chromosome.*.fa.gz

cat $(ls Danio_rerio.GRCz10.dna.chromosome.*.fa.gz | sort -n -t . -k 5) > grcz10-sequence-ensembl-v1.fa.gz
bgzip -fd grcz10-sequence-ensembl-v1.fa.gz
samtools faidx grcz10-sequence-ensembl-v1.fa
