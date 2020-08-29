#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset


## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Process GTF file
wget --quiet ftp://ftp.ensembl.org/pub/release-100/gtf/homo_sapiens/Homo_sapiens.GRCh38.100.gtf.gz 

cat <(gzip -dc Homo_sapiens.GRCh38.100.gtf.gz | grep "^#") <(gzip -dc Homo_sapiens.GRCh38.100.gtf.gz | grep -v "^#") \
    | awk -v OFS="\t" 'BEGIN{print "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} { if ( $3 == "gene") print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch38-gene-only-features-ensembl-v1.gtf.gz

tabix grch38-gene-only-features-ensembl-v1.gtf.gz

rm Homo_sapiens.GRCh38.100.gtf.gz
