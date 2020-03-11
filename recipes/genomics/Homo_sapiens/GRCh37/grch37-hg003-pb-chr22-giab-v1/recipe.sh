#!/bin/sh
set -eo pipefail -o nounset
#download HG003 data, convert to fastq
wget -q ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG003_NA24149_father/PacBio_MtSinai_NIST/CSHL_bwamem_bam_GRCh37/BWA-MEM_Chr22_HG003_merged_11_12.sort.bam
samtools fastq BWA-MEM_Chr22_HG003_merged_11_12.sort.bam > chr22_pb_HG003_dad.fastq
rm BWA-MEM_Chr22_HG003_merged_11_12.sort.bam
bgzip chr22_pb_HG003_dad.fastq
samtools faidx chr22_pb_HG003_dad.fastq.gz
