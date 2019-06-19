#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset


## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Danio_rerio/danRer10/danRer10.genome

##  Create the remap sed file
##  UCSC <-> Ensembl mapping at: https://github.com/dpryan79/ChromosomeMappings  
##  Any unmapped regions will be deleted 
wget --quiet -O - https://raw.githubusercontent.com/dpryan79/ChromosomeMappings/master/GRCz10_ensembl2UCSC.txt \
    | awk '{if(NF==2) print "s/^"$1"/"$2"/g"; else if(NF==1) print "/^"$1"/d"}' > remap.sed

## Get Ensembl gtf file
wget --quiet -O - ftp://ftp.ensembl.org/pub/release-91/gtf/danio_rerio/Danio_rerio.GRCz10.91.gtf.gz \
    | gzip -dc \
    | sed -f remap.sed \
    | gsort /dev/stdin $genome \
    | bgzip -c > danrer10-gtf-ensembl-v1.gtf.gz

tabix danrer10-gtf-ensembl-v1.gtf.gz

rm remap.sed
