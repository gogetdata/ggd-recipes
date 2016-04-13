#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/mm10/problem_regions.yaml

mkdir -p $PREFIX/share/ggd/Mus_musculus/mm10/mm10-problem_regions/ && cd $PREFIX/share/ggd/Mus_musculus/mm10/mm10-problem_regions/

repeats=coverage/problem_regions/repeats
mkdir -p $repeats
wget -O - http://files.figshare.com/1688228/LCR_mm10.bed.gz | gunzip -c | bgzip -c > $repeats/LCR.bed.gz
tabix -p vcf -f $repeats/LCR.bed.gz
