#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/1000g_omni_snps.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-1000g_omni_snps/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-1000g_omni_snps/

baseurl=ftp://gsapubftp-anonymous:none@ftp.broadinstitute.org/bundle/2.8/hg19/1000G_omni2.5.hg19.sites.vcf.gz
mkdir -p variation
cd variation
wget -O - $baseurl | gunzip -c | bgzip -c > 1000G_omni2.5.vcf.gz
tabix -f -p vcf  1000G_omni2.5.vcf.gz
