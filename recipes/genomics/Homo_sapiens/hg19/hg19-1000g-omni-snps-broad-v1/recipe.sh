#!/bin/sh
set -eo pipefail -o nounset
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

wget --quiet -O - ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg19/1000G_omni2.5.hg19.sites.vcf.gz \
    | gzip -dc \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-1000g-omni-snps-braod-v1.vcf.gz 

tabix hg19-1000g-omni-snps-braod-v1.vcf.gz 
