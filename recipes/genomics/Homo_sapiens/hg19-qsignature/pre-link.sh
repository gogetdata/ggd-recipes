#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/qsignature.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=http://downloads.sourceforge.net/project/adamajava/qsignature.tar.bz2
mkdir -p variation
cd variation
wget --quiet -N -c $baseurl
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome
tar -xjf qsignature.tar.bz2 qsignature_positions.txt
rm qsignature.tar.bz2
echo "##fileformat=VCFv4.1" > qsignature.vcf
echo "#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO" >> qsignature.vcf
awk 'BEGIN{FS=OFS="\t"}($1 ~ /^#/){ print }($1 !~ /^#/ && NF == 7) { $4="N"; print}' qsignature_positions.txt >> qsignature.vcf

gsort qsignature.vcf $genome | bgzip -c > qsignature.vcf.gz
tabix qsignature.vcf.gz
rm qsignature_positions.txt qsignature.vcf

