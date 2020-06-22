#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get Chrom mapping file
chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/rmsk.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=rep&hgta_track=rmsk&hgta_table=rmsk&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tstrand\trelativeStart\trelativeEnd\trepeatName\trepeatClass\trepeatFamily\tclass_family_name\tdiv\tdel\tins\tdiv+del+ins"} {print $6,$7,$8,$10,$14,$15,$11,$12,$13,$12"_"$13"_"$11,$3,$4,$5,$3+$4+$5}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch38-repeatmasker-ucsc-v1.bed.gz

tabix grch38-repeatmasker-ucsc-v1.bed.gz
