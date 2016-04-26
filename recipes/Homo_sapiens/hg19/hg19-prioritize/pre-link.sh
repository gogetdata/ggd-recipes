#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/prioritize.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=https://s3.amazonaws.com/biodata/coverage/prioritize/prioritize-cancer-hg19-20160215.tar.gz
outdir=coverage/prioritize
mkdir -p $outdir
cd $outdir
wget --quiet --no-check-certificate -c -O cancer.tar.gz $baseurl
tar -xzvpf cancer.tar.gz
rm cancer.tar.gz
cd cancer
rm *.tbi

wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome

for f in *.bed.gz; do
	gsort $f hg19.genome | bgzip -c > tmp
	mv tmp $f
	tabix $f
done

rm hg19.genome
