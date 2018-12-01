#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/prioritize.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

baseurl=https://s3.amazonaws.com/biodata/coverage/prioritize/prioritize-cancer-GRCh37-20160215.tar.gz
outdir=coverage/prioritize
mkdir -p $outdir
cd $outdir
wget --quiet --no-check-certificate -c -O cancer.tar.gz $baseurl
tar -xzvpf cancer.tar.gz
rm cancer.tar.gz
rm cancer/*.tbi

wget --quiet --no-check-certificate https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome
genome=GRCh37.genome
ls cancer/

mkdir -p c2
for f in cancer/*.bed.gz; do
	gsort $f $genome | bgzip -c > c2/$(basename $f)
	tabix c2/$(basename $f)
	rm $f
done
rm -r cancer/
mv c2 cancer
rm $genome
