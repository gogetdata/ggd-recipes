#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset

##Convert a UCSC table to a gtf file using "genePredToGTF"
### http://genomewiki.ucsc.edu/index.php/Genes_in_gtf_or_gff_format

##Get genePredToGTF from UCSC depending on system platform
if [[ $OSTYPE == darwin* ]]; then
    wget --quiet http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/genePredToGtf
    
elif [[ $OSTYPE == linux* ]]; then
    wget --quiet http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/genePredToGtf
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

chmod +x genePredToGtf

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Danio_rerio/danRer10/danRer10.genome

## Convert the refGene table to a gtf file.
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenPath/danRer10/database/refGene.txt.gz \
    | gzip -dc \
    | cut -f 2- \
    | ./genePredToGtf file stdin /dev/stdout \
    | sed -e 's/stdin/genePredToGtf/' \
    | gsort /dev/stdin $genome \
    | bgzip -c > danrer10-gtf-refseq-ucsc-v1.gtf.gz

tabix danrer10-gtf-refseq-ucsc-v1.gtf.gz


rm genePredToGtf
