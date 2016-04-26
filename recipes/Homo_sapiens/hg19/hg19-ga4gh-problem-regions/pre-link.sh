#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/GA4GH_problem_regions.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=http://bcbio_nextgen.s3.amazonaws.com/GA4GH_problem_regions.zip
mkdir -p coverage/problem_regions/GA4GH
cd coverage/problem_regions/GA4GH
wget --quiet --no-check-certificate -c -O GA4GH_problem_regions.zip $baseurl
unzip -o GA4GH_problem_regions.zip
rm GA4GH_problem_regions.zip
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome

for f in ./*.bed; do
	gsort $f $genome | bgzip -c > $f.gz
	tabix $f.gz
	rm $f;
done
cd ../../..

encode=coverage/problem_regions/ENCODE
mkdir -p $encode

wget --no-check-certificate -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeMapability/wgEncodeDacMapabilityConsensusExcludable.bed.gz | gsort /dev/stdin $genome | bgzip -c > $encode/wgEncodeDacMapabilityConsensusExcludable.bed.gz
tabix $encode/wgEncodeDacMapabilityConsensusExcludable.bed.gz

repeats=coverage/problem_regions/repeats
mkdir -p $repeats
wget --no-check-certificate -O - https://raw.githubusercontent.com/chapmanb/delly/master/human.hg19.excl.tsv | grep ^chr | grep -wv chrMT | gsort /dev/stdin $genome | bgzip -c > $repeats/sv_repeat_telomere_centromere.bed.gz
tabix $repeats/sv_repeat_telomere_centromere.bed.gz

wget --no-check-certificate -O - https://github.com/lh3/varcmp/raw/master/scripts/LCR-hs37d5.bed.gz | zgrep -v ^GL | grep -v ^NC | grep -v ^hs | sed 's/^/chr/' | gsort /dev/stdin $genome | bgzip -c > $repeats/LCR.bed.gz
tabix -p bed -f $repeats/LCR.bed.gz



