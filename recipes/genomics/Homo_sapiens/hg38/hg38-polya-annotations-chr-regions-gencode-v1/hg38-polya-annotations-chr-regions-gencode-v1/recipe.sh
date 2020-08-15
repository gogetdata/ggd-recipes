#!/bin/sh
set -eo pipefail -o nounset
## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

## Get GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.polyAs.gtf.gz 

cat <(gzip -dc gencode.v34.polyAs.gtf.gz | grep "^#") <(echo -e "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute") <(gzip -dc gencode.v34.polyAs.gtf.gz | grep -v "^#") \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-polya-gencode-v1.gtf.gz

tabix hg38-polya-gencode-v1.gtf.gz

rm gencode.v34.polyAs.gtf.gz
