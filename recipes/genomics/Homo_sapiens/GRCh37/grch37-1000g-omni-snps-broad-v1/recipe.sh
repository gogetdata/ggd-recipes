#!/bin/sh
set -eo pipefail -o nounset
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

wget --quiet -O - ftp://gsapubftp-anonymous:none@ftp.broadinstitute.org/bundle/b37/1000G_omni2.5.b37.vcf.gz \
    | gzip -dc \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-1000g-omni-snps-braod-v1.vcf.gz 

tabix grch37-1000g-omni-snps-braod-v1.vcf.gz 
