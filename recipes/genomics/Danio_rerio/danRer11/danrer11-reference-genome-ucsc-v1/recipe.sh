#!/bin/sh
set -eo pipefail -o nounset


if [[ $OSTYPE == darwin* ]]; then
    wget --quiet http://hgdownload.cse.ucsc.edu/admin/exe/macOSX.x86_64/twoBitToFa 

elif [[ $OSTYPE == linux* ]]; then
    wget --quiet http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/twoBitToFa

else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi
chmod +x twoBitToFa

## Download danRer11.2bit
wget --quiet ftp://hgdownload.soe.ucsc.edu/goldenPath/danRer11/bigZips/danRer11.2bit 

## convert to .fa
./twoBitToFa danRer11.2bit danrer11-reference-genome-ucsc-v1.fa

## Index reference genome
samtools faidx danrer11-reference-genome-ucsc-v1.fa 


## Remove twoBitToFa
rm twoBitToFa
rm danRer11.2bit
