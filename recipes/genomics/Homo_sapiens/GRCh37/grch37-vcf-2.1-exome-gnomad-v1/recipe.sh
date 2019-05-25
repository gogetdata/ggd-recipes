#!/bin/sh
set -eo pipefail -o nounset


wget --quiet -O - https://storage.googleapis.com/gnomad-public/release/2.1.1/vcf/exomes/gnomad.exomes.r2.1.1.sites.vcf.bgz \
    | bcftools view --threads 3 -O v \
    | bgzip -c > grch37-vcf-2.1-gnomad-v1.vcf.gz

tabix grch37-vcf-2.1-gnomad-v1.vcf.gz
