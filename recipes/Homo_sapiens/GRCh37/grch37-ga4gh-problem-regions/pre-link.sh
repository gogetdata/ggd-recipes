#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/GA4GH_problem_regions.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

baseurl=http://bcbio_nextgen.s3.amazonaws.com/GA4GH_problem_regions.zip
mkdir -p coverage/problem_regions/GA4GH
cd coverage/problem_regions/GA4GH
wget --no-check-certificate -c -O GA4GH_problem_regions.zip $baseurl
unzip -o GA4GH_problem_regions.zip
for file in *.bed
do
  sed 's/^chr//g'  $file > $file.tmp
  mv $file.tmp $file
done
cd ../../..
encode=coverage/problem_regions/ENCODE
mkdir -p $encode
wget --no-check-certificate -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeMapability/wgEncodeDacMapabilityConsensusExcludable.bed.gz | gunzip -c | sed "s/^chrM/MT/g" | sed "s/^chr//g" > $encode/wgEncodeDacMapabilityConsensusExcludable.bed
repeats=coverage/problem_regions/repeats
mkdir -p $repeats
wget --no-check-certificate -O - https://raw.githubusercontent.com/chapmanb/delly/master/human.hg19.excl.tsv | grep -v ^chr > $repeats/sv_repeat_telomere_centromere.bed
wget --no-check-certificate -O - https://github.com/lh3/varcmp/raw/master/scripts/LCR-hs37d5.bed.gz | gunzip -c  | bgzip -c > $repeats/LCR.bed.gz
tabix -p vcf -f $repeats/LCR.bed.gz

