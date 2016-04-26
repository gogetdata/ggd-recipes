#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/canFam3/transcripts.yaml

mkdir -p $PREFIX/share/ggd/Canis_familiaris/canFam3/ && cd $PREFIX/share/ggd/Canis_familiaris/canFam3/

baseurl=https://s3.amazonaws.com/biodata/annotation/canFam3-rnaseq-2014-07-20.tar.xz
wget --quiet -c -N $baseurl

mkdir -p rnaseq/
tar xpvf *-rnaseq-*.tar.xz -C rnaseq/ --strip-components=2
#xz -dc *-rnaseq-*.tar.xz | tar -xpf -
rm *.tar.xz
cd rnaseq
ls

wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/canFam3/canFam3.genome
for f in ./{tophat,}/*.g{f,t}f; do
	echo $f
    gsort $f canFam3.genome | bgzip -c > $f.gz
    tabix $f.gz
    rm $f
done
rm canFam3.genome



