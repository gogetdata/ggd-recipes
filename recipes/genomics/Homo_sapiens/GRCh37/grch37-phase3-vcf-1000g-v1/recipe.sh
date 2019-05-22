#!/bin/sh
set -eo pipefail -o nounset

## Activate the ggd environment variables. (In order to gain access to the grch37-seqeunce-1000g-v1 env-vars)
activate base

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Download daata, sort it using gsort, decompose and normalize using vt, (Using the ggd package grch37-seqeunce-1000g-v1 as the 
##  reference genome and using the env-var created for that recipe), bgzip it, and tabix it. 
wget --quiet -O - ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.vcf.gz \
    | gsort /dev/stdin $genome \
    | vt decompose -s - \
    | vt normalize -r $ggd_grch37_sequence_1000g_v1_file -w 500000 - \
    | bgzip -c > grch37-phase3-vcf-1000g-v1.vcf.gz

tabix grch37-phase3-vcf-1000g-v1.vcf.gz

