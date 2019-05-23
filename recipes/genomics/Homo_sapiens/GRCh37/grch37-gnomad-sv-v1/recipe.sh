#!/bin/sh
set -eo pipefail -o nounset
#download SVs from gnomAD (HG19) in bgzipped VCF format
wget --quiet https://storage.googleapis.com/gnomad-public/papers/2019-sv/gnomad_v2_sv.sites.vcf.gz

#sort and tabix
gsort gnomad_v2_sv.sites.vcf.gz https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome | bgzip -c > gnomad_v2_sv_sorted.sites.vcf.gz
tabix -p vcf gnomad_v2_sv_sorted.sites.vcf.gz

#clean up
rm gnomad_v2_sv.sites.vcf.gz
