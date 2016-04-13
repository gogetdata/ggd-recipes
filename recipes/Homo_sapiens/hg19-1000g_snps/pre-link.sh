#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/1000g_snps.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-1000g_snps/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-1000g_snps/

baseurl=ftp://gsapubftp-anonymous:none@ftp.broadinstitute.org/bundle/2.8/hg19/1000G_phase1.snps.high_confidence.hg19.sites.vcf.gz
mkdir -p variation
cd variation
wget -O - $baseurl | gunzip -c | bgzip -c > 1000G_phase1.snps.high_confidence.vcf.gz
tabix -f -p vcf 1000G_phase1.snps.high_confidence.vcf.gz
