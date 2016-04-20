#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/bwa.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

url=ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome
base=GRCh38_full_analysis_set_plus_decoy_hla.fa
new=hg38.fa
mkdir -p bwa
for suffix in .bwt .amb .ann .pac .sa .alt
do
  [[ -f bwa/$new$suffix ]] || wget --quiet -c -O bwa/$new$suffix $url/$base$suffix
done

