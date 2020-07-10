#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")
awk '{if (NR > 1) print $1,$2} ' $chrom_mapping \
    | sort -k2,2n -r \
    | awk '{print "s/"$1"/"$2"/g"}' > remap.sed

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/chainSelf.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=rep&hgta_track=chainSelf&hgta_table=chainSelf&hgta_doSchema=describe+table+schema\n#target_chrom\ttarget_start\ttarget_end\ttarget_size\tquery_chrom\tquery_start\tquery_end\tquery_size\tquery_strand\tchain_id\tscore\tnormalized_score"} 
                             {print $3,$5,$6,$4,$7,$10,$11,$8,$9,$12,$2,$13}' \
    | sed -f remap.sed \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-selfchain-ucsc-v1.bed.gz

tabix grch37-selfchain-ucsc-v1.bed.gz

#rm remap.sed

