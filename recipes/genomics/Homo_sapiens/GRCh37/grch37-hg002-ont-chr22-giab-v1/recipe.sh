#!/bin/sh
set -eo pipefail -o nounset
reference=$(ggd get-files grch37-reference-genome-ensembl-v1 -s 'Homo_sapiens' -g "GRCh37" -p "*.fa")

wget -q ftp://ftp-trace.ncbi.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/CORNELL_Oxford_Nanopore/giab.hg002.2D.fastq
minimap2 -t 1 -ax map-ont $reference giab.hg002.2D.fastq \
    | samtools view -hSb /dev/stdin \
    | samtools sort /dev/stdin \
    > giab.hg002.ont.bam

samtools index giab.hg002.ont.bam
samtools view -hb giab.hg002.ont.bam "22" > chr22_hg002_ont.bam
samtools index chr22_hg002_ont.bam

#clean up
rm giab.hg002.2D.fastq
rm giab.hg002.ont.bam
rm giab.hg002.ont.bam.bai
