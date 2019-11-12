#!/bin/sh
set -eo pipefail -o nounset
#download HG002 data, convert to fastq
wget -q ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG004_NA24143_mother/PacBio_MtSinai_NIST/CSHL_bwamem_bam_GRCh37/BWA-MEM_Chr22_HG004_merged_11_12.sort.bam
samtools fastq BWA-MEM_Chr22_HG004_merged_11_12.sort.bam > chr22_pb_HG004_mom.fastq
rm BWA-MEM_Chr22_HG004_merged_11_12.sort.bam
bgzip chr22_pb_HG004_mom.fastq
samtools faidx chr22_pb_HG004_mom.fastq.gz
