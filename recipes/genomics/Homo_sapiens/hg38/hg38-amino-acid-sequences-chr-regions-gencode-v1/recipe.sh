#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset

wget --quiet -O - ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.pc_translations.fa.gz\
    | gzip -dc \
    | bgzip -c > hg38_amino_acid-gencode-v1.fa.gz

samtools faidx hg38_amino_acid-gencode-v1.fa.gz
