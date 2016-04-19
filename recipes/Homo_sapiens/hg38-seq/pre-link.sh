#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/seq.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

url=ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome
base=GRCh38_full_analysis_set_plus_decoy_hla
new=hg38
mkdir -p seq
for suffix in .fa .dict .fa.fai
do
  [[ -f seq/$new$suffix ]] || wget -c -O seq/$new$suffix $url/$base$suffix
done

