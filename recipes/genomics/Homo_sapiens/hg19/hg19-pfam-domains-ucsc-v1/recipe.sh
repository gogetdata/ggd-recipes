#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
## Get pfam file from UCSC Genes and processes it into a bed file 
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/ucscGenePfam.txt.gz \
    | gzip -dc \
    | cut -f 2- \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=ucscGenePfam&hgta_table=ucscGenePfam&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tname\tsocre\tstrand\tthickStart\tthickEnd\treserved\tblockCount\tblockSizes\tchromStarts"} {print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-pfam-domains-ucsc-v1.bed12.bed.gz

## index the bed file using tabix
tabix hg19-pfam-domains-ucsc-v1.bed12.bed.gz
