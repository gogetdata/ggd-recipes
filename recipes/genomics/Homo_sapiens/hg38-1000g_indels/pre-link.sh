#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/1000g_indels.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

url=https://s3.amazonaws.com/biodata/hg38_bundle
base=1000G_phase1.indels.b38.primary_assembly
new=1000G_phase1.indels
mkdir -p variation
for suffix in .vcf.gz .vcf.gz.tbi
do
  [[ -f variation/$new$suffix ]] || wget --quiet -c -O variation/$new$suffix $url/$base$suffix
done

