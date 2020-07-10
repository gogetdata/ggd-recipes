#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/chainSelf.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=rep&hgta_track=chainSelf&hgta_table=chainSelf&hgta_doSchema=describe+table+schema\n#target_chrom\ttarget_start\ttarget_end\ttarget_size\tquery_chrom\tquery_start\tquery_end\tquery_size\tquery_strand\tchain_id\tscore\tnormalized_score"} 
                             {print $3,$5,$6,$4,$7,$10,$11,$8,$9,$12,$2,$13}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-selfchain-ucsc-v1.bed.gz

tabix hg38-selfchain-ucsc-v1.bed.gz

