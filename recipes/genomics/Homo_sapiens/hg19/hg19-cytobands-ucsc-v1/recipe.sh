#!/bin/sh
set -eo pipefail -o nounset
## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

# download, header, sort, bgzip
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/cytoBand.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: http://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=map&hgta_track=cytoBand&hgta_table=cytoBand&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tband\tstain"} {print $1,$2,$3,$4,$5}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-cytoband-ucsc-v1.bed.gz

# index the bed file using tabix
tabix hg19-cytoband-ucsc-v1.bed.gz
