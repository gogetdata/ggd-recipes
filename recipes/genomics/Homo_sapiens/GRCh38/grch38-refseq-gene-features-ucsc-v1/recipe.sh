#!/bin/sh
set -eo pipefail -o nounset

##Convert a UCSC table to a gtf file using "genePredToGTF"
### http://genomewiki.ucsc.edu/index.php/Genes_in_gtf_or_gff_format
##Get genePredToGTF from UCSC depending on system platform
if [[ $OSTYPE == darwin* ]]; then
    wget --quiet http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/genePredToGtf
    
elif [[ $OSTYPE == linux* ]]; then
    wget --quiet http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/genePredToGtf
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

chmod +x genePredToGtf

## Get the .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get the chromomsome mapping file
chr_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Convert the refGene table to a gtf file.
wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/refGene.txt.gz \
    | gzip -dc \
    | cut -f 2- \
    | ./genePredToGtf file stdin /dev/stdout \
    | sed -e 's/stdin/genePredToGtf/' \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} {print $0}' \
    | gsort --chromosomemappings $chr_mapping /dev/stdin $genome \
    | bgzip -c > grch38-refseq-gene-features-ucsc-v1.gtf.gz

tabix grch38-refseq-gene-features-ucsc-v1.gtf.gz

rm genePredToGtf
