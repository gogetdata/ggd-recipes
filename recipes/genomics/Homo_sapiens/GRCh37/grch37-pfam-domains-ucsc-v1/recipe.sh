#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get chromosome mapping file 
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")
cp $chrom_mapping grch37-chrom-mapping.txt

## Get pfam file from UCSC Genes and processes it into a bed file 
## unzip it, 
## remove any lines that do not have a scaffolding in the GRCh37.genom file. (If scaffolding in grch37.genome, grep exists with 0)
## add header to the file, and remove the bin column
## sort it based on the genome file
## bgzip it
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/ucscGenePfam.txt.gz \
    | gzip -dc \
    | awk '{ if (system("grep -Fq " $2 "  grch37-chrom-mapping.txt") == 0)  print $0}' \
    | cut -f 2- \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=ucscGenePfam&hgta_table=ucscGenePfam&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tname\tsocre\tstrand\tthickStart\tthickEnd\treserved\tblockCount\tblockSizes\tchromStarts"} {print $0}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-pfam-domains-ucsc-v1.bed12.bed.gz

## index the bed file using tabix
tabix grch37-pfam-domains-ucsc-v1.bed12.bed.gz


rm grch37-chrom-mapping.txt
