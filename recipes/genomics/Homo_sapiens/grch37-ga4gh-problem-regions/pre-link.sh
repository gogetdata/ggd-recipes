#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/GA4GH_problem_regions.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome

baseurl=http://bcbio_nextgen.s3.amazonaws.com/GA4GH_problem_regions.zip
mkdir -p coverage/problem_regions/GA4GH
cd coverage/problem_regions/GA4GH
wget --quiet --no-check-certificate -c -O GA4GH_problem_regions.zip $baseurl
unzip -o GA4GH_problem_regions.zip
rm GA4GH_problem_regions.zip
for file in *.bed
do
  sed 's/^chr//g'  $file | grep -v ^NC | grep -v ^Un | grep -v _random | sed 's/^M/MT/' > $file.tmp
  gsort $file.tmp https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome | bgzip -c > ${file}.gz
  rm $file.tmp
  rm $file
  tabix ${file}.gz
done
cd ../../..
encode=coverage/problem_regions/ENCODE
mkdir -p $encode
wget --quiet --no-check-certificate -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeMapability/wgEncodeDacMapabilityConsensusExcludable.bed.gz | gunzip -c | sed "s/^chrM/MT/" | sed "s/^chr//" | grep -v ^NC | gsort /dev/stdin $genome | bgzip -c > $encode/wgEncodeDacMapabilityConsensusExcludable.bed.gz
tabix $encode/wgEncodeDacMapabilityConsensusExcludable.bed.gz

repeats=coverage/problem_regions/repeats
mkdir -p $repeats
wget --quiet --no-check-certificate -O - https://raw.githubusercontent.com/chapmanb/delly/master/human.hg19.excl.tsv | grep -v ^chr | grep -v ^NC | grep -vw chrM | grep -v hs37 | gsort /dev/stdin $genome | bgzip -c > $repeats/sv_repeat_telomere_centromere.bed.gz
tabix $repeats/sv_repeat_telomere_centromere.bed.gz

wget --quiet --no-check-certificate -O - https://github.com/lh3/varcmp/raw/master/scripts/LCR-hs37d5.bed.gz | zgrep -v "^NC" | grep -v ^hs37 | gsort /dev/stdin https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome | bgzip -c > $repeats/LCR.bed.gz
tabix -p bed -f $repeats/LCR.bed.gz

