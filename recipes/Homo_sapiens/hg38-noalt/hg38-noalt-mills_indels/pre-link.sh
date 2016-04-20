#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38-noalt/mills_indels.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/

url=https://s3.amazonaws.com/biodata/hg38_bundle
base=Mills_and_1000G_gold_standard.indels.b38.primary_assembly
new=Mills_and_1000G_gold_standard.indels
mkdir -p variation
for suffix in .vcf.gz .vcf.gz.tbi
do
  [[ -f variation/$new$suffix ]] || wget --quiet --no-check-certificate -c -O variation/$new$suffix $url/$base$suffix
done

