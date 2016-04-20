#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38-noalt/coverage.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/

repeats=coverage/problem_regions/repeats
mkdir -p $repeats
url=https://gist.githubusercontent.com/chapmanb/4c40f961b3ac0a4a22fd/raw/2025f3912a477edc597e61d911bd1044dc943440/sv_repeat_telomere_centromere.bed
wget --quiet --no-check-certificate -O - $url > $repeats/sv_repeat_telomere_centromere.bed
url=https://github.com/lh3/varcmp/raw/bb5b616526c5c3ecb46abfd9877e1bd6d50d1802/scripts/LCR-hs38.bed.gz
out=$repeats/LCR.bed.gz
wget --no-check-certificate -O $out -c $url
tabix -f -p bed $out

