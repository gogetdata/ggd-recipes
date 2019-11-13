#!/bin/sh
set -eo pipefail -o nounset
reference=$(ggd get-files hg19-reference-genome-ucsc-v1 -s 'Homo_sapiens' -g 'hg19' -p '*.fa')

wget -q ftp://ftp-trace.ncbi.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/CORNELL_Oxford_Nanopore/giab.hg002.2D.fastq
minimap2 -t 1 -ax map-ont $reference giab.hg002.2D.fastq \
    | samtools view -hSb /dev/stdin \
    | samtools sort /dev/stdin \
    > giab.hg002.ont.bam
rm giab.hg002.2D.fastq

samtools index giab.hg002.ont.bam
samtools view -hb giab.hg002.ont.bam "chr22" > chr22_hg002_ont.bam
rm giab.hg002.ont.bam
rm giab.hg002.ont.bam.bai
samtools index chr22_hg002_ont.bam
