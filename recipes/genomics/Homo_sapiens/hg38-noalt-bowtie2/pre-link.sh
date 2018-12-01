#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38-noalt/bowtie2.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/

base=GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index
new=hg38-noalt.fa
ncbiurl=ftp://ftp.ncbi.nlm.nih.gov/genbank/genomes/Eukaryotes/vertebrates_mammals/Homo_sapiens/GRCh38/seqs_for_alignment_pipelines
wget --quiet -c $ncbiurl/$base.tar.gz
[[ -f $base.1.bt2 ]] || tar -xzvpf $base.tar.gz
mkdir -p bowtie2
for suffix in .1.bt2 .2.bt2 .3.bt2 .4.bt2 .rev.1.bt2 .rev.2.bt2
do
  [[ -f bowtie2/$new$suffix ]] || mv -f $base$suffix bowtie2/$new$suffix
done

