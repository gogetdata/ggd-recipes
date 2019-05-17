#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

wget --queit -O - ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/1000G_phase1.snps.high_confidence.b37.vcf.gz 
    | gzip -dc \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-1000g-snps-phase1-broad-v1.vcf.gz \

tabix grch37-1000g-snps-phase1-broad-v1.vcf.gz 
