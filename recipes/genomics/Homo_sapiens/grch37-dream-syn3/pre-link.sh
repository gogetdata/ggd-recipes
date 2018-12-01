#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/dream-syn3.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

dir=validation/dream-syn3
orig=synthetic_challenge_set3_tumor_20pctmasked_truth
mkdir -p $dir
wget --quiet --no-check-certificate https://s3.amazonaws.com/bcbio_nextgen/dream/synthetic_challenge_set3_tumor_20pctmasked_truth.tar.gz
tar -xzvpf synthetic_challenge_set3_tumor_20pctmasked_truth.tar.gz

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome
gsort ${orig}.vcf.gz genome | bgzip -c > $dir/truth_small_variants.vcf.gz
tabix $dir/truth_small_variants.vcf.gz
rm ${orig}.vcf.gz

gsort ${orig}_regions.bed $genome | bgzip -c > $dir/truth_regions.bed.gz
gsort ${orig}_sv_DEL.bed $genome | bgzip -c > $dir/truth_DEL.bed .gz
gsort ${orig}_sv_DUP.bed $genome | bgzip -c > $dir/truth_DUP.bed.gz
gsort ${orig}_sv_INS.bed $genome | bgzip -c > $dir/truth_INS.bed.gz
gsort ${orig}_sv_INV.bed $genome | bgzip -c > $dir/truth_INV.bed.gz
for f in $dir/*.bed.gz; do
	tabix $f
done

rm ${orig}_*.bed
rm synthetic_challenge_set3_tumor_20pctmasked_truth.tar.gz
