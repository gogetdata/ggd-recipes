#!/bin/sh
set -eo pipefail -o nounset
## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

## Get GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh37_mapping/gencode.v34lift37.long_noncoding_RNAs.gtf.gz


cat <(gzip -dc gencode.v34lift37.long_noncoding_RNAs.gtf.gz | grep "^#") <(echo -e "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute") <(gzip -dc gencode.v34lift37.long_noncoding_RNAs.gtf.gz | grep -v "^#") \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-long_noncoding_RNAs-gencode-v1.gtf.gz


tabix hg19-long_noncoding_RNAs-gencode-v1.gtf.gz

rm gencode.v34lift37.long_noncoding_RNAs.gtf.gz
