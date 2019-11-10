#!/bin/sh
set -eo pipefail -o nounset
set -eo
#download HG003 data, convert to fastq, align with minimap, call SVs
wget -q ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG003_NA24149_father/PacBio_MtSinai_NIST/CSHL_bwamem_bam_GRCh37/BWA-MEM_Chr22_HG003_merged_11_12.sort.bam
bedtools bamtofastq -i BWA-MEM_Chr22_HG003_merged_11_12.sort.bam -fq chr22_pb_HG003_dad.fastq
rm BWA-MEM_Chr22_HG003_merged_11_12.sort.bam
bgzip chr22_pb_HG003_dad.fastq
