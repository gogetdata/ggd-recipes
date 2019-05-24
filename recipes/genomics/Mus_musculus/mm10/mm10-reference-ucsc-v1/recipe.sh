#!/bin/sh
set -eo pipefail -o nounset
#download the reference
wget -q http://hgdownload.cse.ucsc.edu/goldenPath/mm10/bigZips/mm10.2bit

#grab converter
unameOut="$(uname -s)"
url=""
if [[ "$unameOut" == *"Linux"* ]]
then
    url="http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/twoBitToFa";
else
    url="http://hgdownload.cse.ucsc.edu/admin/exe/macOSX.x86_64/twoBitToFa";
fi
echo "$url"
wget -q "$url"
chmod +x twoBitToFa

#convert 2bit to fa and index
twoBitToFa mm10.2bit mm10-reference-genome-ucsc-v1.fa
samtools faidx mm10-reference-genome-ucsc-v1.fa

#clean up
rm mm10.2bit
rm twoBitToFa
