#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/1000g_omni_snps.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

url=https://s3.amazonaws.com/biodata/hg38_bundle
base=1000G_omni2.5.b38.primary_assembly
new=1000G_omni2.5
mkdir -p variation
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg38/hg38.genome

for suffix in .vcf.gz .vcf.gz.tbi
do
  [[ -f variation/$new$suffix ]] || wget --quiet -c -O - \
	  | gsort /dev/stdin $genome \
	  | bgzip - c \
	  > variation/$new$suffix $url/$base$suffix
done

