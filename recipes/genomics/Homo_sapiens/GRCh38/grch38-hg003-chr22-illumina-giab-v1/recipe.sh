#!/bin/sh
set -eo pipefail -o nounset
#download HG003 data
samtools view -s .1 -b ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG003_NA24149_father/NIST_HiSeq_HG003_Homogeneity-12389378/NHGRI_Illumina300X_AJtrio_novoalign_bams/HG003.GRCh38.300x.bam "chr22" |
    samtools sort > hg003.chr22.bam
samtools index hg003.chr22.bam
rm HG003.GRCh38.300x.bam.bai
