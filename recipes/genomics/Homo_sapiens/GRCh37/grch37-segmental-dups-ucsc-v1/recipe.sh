#!/bin/sh
set -eo pipefail -o nounset

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/genomicSuperDups.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=rep&hgta_track=genomicSuperDups&hgta_table=genomicSuperDups&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tname\tscore\tstrand\totherChrom\totherStart\totherEnd\totherSize\tunique_id\tposBasesHit\ttestResult\tverdict\tchits\tccov\talignfile\talignL\tindelN\tindelS\talignB\tmatchB\tmismatchB\ttransitionsB\ttransversionsB\tfracMatch\tfracMatchIndel\tjcK\tk2K"} 
                             {print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $30}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-segmental-dups-ucsc-v1.bed.gz

tabix grch37-segmental-dups-ucsc-v1.bed.gz
