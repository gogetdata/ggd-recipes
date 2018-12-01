#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38-noalt/seq.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/

mkdir -p sequence
wget --quiet -c -O sequence/hg38-noalt.fa.gz ftp://ftp.ncbi.nlm.nih.gov/genbank/genomes/Eukaryotes/vertebrates_mammals/Homo_sapiens/GRCh38/seqs_for_alignment_pipelines/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
[[ -f sequence/hg38-noalt.fa ]] || gunzip -c sequence/hg38-noalt.fa.gz > sequence/hg38-noalt.fa


wget --quiet -c -O sequence/hg38-noalt.fa.fai ftp://ftp.ncbi.nlm.nih.gov/genbank/genomes/Eukaryotes/vertebrates_mammals/Homo_sapiens/GRCh38/seqs_for_alignment_pipelines/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.fai

[[ -f sequence/hg38-noalt.dict ]] || picard CreateSequenceDictionary REFERENCE=sequence/hg38-noalt.fa OUTPUT=sequence/hg38-noalt.dict SPECIES=hg38-noalt

