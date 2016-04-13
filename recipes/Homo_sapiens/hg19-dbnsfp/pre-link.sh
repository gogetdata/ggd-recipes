#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/dbnsfp.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-dbnsfp/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-dbnsfp/

baseurl=ftp://dbnsfp:dbnsfp@dbnsfp.softgenetics.com/dbNSFPv3.1c.zip
mkdir -p variation
cd variation
wget -c -N $baseurl
7za x dbNSFPv*.zip -y -otmp-unpack
cat tmp-unpack/dbNSFP*_variant.chr* | bgzip -c > dbNSFP.txt.gz
tabix -s 1 -b 2 -e 2 -c '#' dbNSFP.txt.gz
rm -f tmp-unpack/* && rmdir tmp-unpack
rm -f dbNSFPv*.zip
