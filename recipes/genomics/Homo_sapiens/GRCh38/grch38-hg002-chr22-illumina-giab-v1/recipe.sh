#!/bin/sh
set -eo pipefail -o nounset
#download HG002 data
samtools view -s .1 -b ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/NIST_HiSeq_HG002_Homogeneity-10953946/NHGRI_Illumina300X_AJtrio_novoalign_bams/HG002.GRCh38.300x.bam "chr22" |
    samtools sort > hg002.chr22.bam
samtools index hg002.chr22.bam
rm HG002.GRCh38.300x.bam.bai
