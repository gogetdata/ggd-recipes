#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/hapmap_snps.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

url=https://s3.amazonaws.com/biodata/hg38_bundle
base=hapmap_3.3.b38.primary_assembly
new=hapmap_3.3
mkdir -p variation
for suffix in .vcf.gz .vcf.gz.tbi
do
  [[ -f variation/$new$suffix ]] || wget --quiet -c -O variation/$new$suffix $url/$base$suffix
done

