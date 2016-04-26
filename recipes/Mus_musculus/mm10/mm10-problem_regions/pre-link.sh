#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/mm10/problem_regions.yaml

mkdir -p $PREFIX/share/ggd/Mus_musculus/mm10/ && cd $PREFIX/share/ggd/Mus_musculus/mm10/

repeats=coverage/problem_regions/repeats
mkdir -p $repeats
wget --quiet -O - http://files.figshare.com/1688228/LCR_mm10.bed.gz | gunzip -c | gsort /dev/stdin https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/mm10/mm10.genome | bgzip -c > $repeats/LCR.bed.gz
tabix -p vcf -f $repeats/LCR.bed.gz

