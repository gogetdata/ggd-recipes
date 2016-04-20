#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38-noalt/bwa.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/

base=GCA_000001405.15_GRCh38_no_alt_analysis_set.fna
new=hg38-noalt.fa
ncbiurl=ftp://ftp.ncbi.nlm.nih.gov/genbank/genomes/Eukaryotes/vertebrates_mammals/Homo_sapiens/GRCh38/seqs_for_alignment_pipelines
wget --quiet -c $ncbiurl/$base.bwa_index.tar.gz
[[ -f $base.fna.bwt ]] || tar -xzvpf $base.bwa_index.tar.gz
mkdir -p bwa
for suffix in .bwt .amb .ann .pac .sa
do
  [[ -f bwa/$new$suffix ]] || mv -f $base$suffix bwa/$new$suffix
done

