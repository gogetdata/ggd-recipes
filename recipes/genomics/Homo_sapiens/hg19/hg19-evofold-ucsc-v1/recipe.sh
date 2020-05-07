#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/evofold.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=evofold&hgta_table=evofold&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tUCSC_event_name\tsize\tscore\tstrand\tmRNAsecstruct\tsecondary_struct_conf"} {print $2,$3,$4,$5,$8,$6,$7,$9,$10}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-evofold-ucsc-v1.bed.gz

tabix hg19-evofold-ucsc-v1.bed.gz
