#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/genomicSuperDups.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=rep&hgta_track=genomicSuperDups&hgta_table=genomicSuperDups&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tname\tscore\tstrand\totherChrom\totherStart\totherEnd\totherSize\tunique_id\tposBasesHit\ttestResult\tverdict\tchits\tccov\talignfile\talignL\tindelN\tindelS\talignB\tmatchB\tmismatchB\ttransitionsB\ttransversionsB\tfracMatch\tfracMatchIndel\tjcK\tk2K"} 
                             {print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-segmental-dups-ucsc-v1.bed.gz

tabix hg38-segmental-dups-ucsc-v1.bed.gz
