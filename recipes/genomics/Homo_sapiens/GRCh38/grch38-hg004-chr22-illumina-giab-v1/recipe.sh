#!/bin/sh
set -eo pipefail -o nounset
#download HG004 data
samtools view -s .1 -b ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG004_NA24143_mother/NIST_HiSeq_HG004_Homogeneity-14572558/NHGRI_Illumina300X_AJtrio_novoalign_bams/HG004.GRCh38.300x.bam "chr22" |
    samtools sort > hg004.chr22.bam
samtools index hg004.chr22.bam
rm HG004.GRCh38.300x.bam.bai
