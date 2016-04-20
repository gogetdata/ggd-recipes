#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38-noalt/1000g_omni_snps.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/

url=https://s3.amazonaws.com/biodata/hg38_bundle
base=1000G_omni2.5.b38.primary_assembly
new=1000G_omni2.5
mkdir -p variation
for suffix in .vcf.gz .vcf.gz.tbi
do
  [[ -f variation/$new$suffix ]] || wget --quiet -c -O variation/$new$suffix $url/$base$suffix
done

