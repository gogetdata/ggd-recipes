#!/bin/sh
set -eo pipefail -o nounset
wget --quiet http://evs.gs.washington.edu/evs_bulk_data/ESP6500SI-V2-SSA137.GRCh38-liftover.snps_indels.vcf.tar.gz

# extract individual chromosome files
tar -zxf ESP6500SI-V2-SSA137.GRCh38-liftover.snps_indels.vcf.tar.gz

# combine chromosome files into one 
(grep ^# ESP6500SI-V2-SSA137.GRCh38-liftover.chr1.snps_indels.vcf; cat ESP6500SI-V2-SSA137.GRCh38-liftover.chr*.snps_indels.vcf | grep ^[^#] ) > temp.vcf

# sort the chromosome data according to the .genome file from github
gsort temp.vcf https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome \
    | bgzip -c > ESP6500SI.all.snps_indels.vcf.gz

# tabix it
tabix -p vcf ESP6500SI.all.snps_indels.vcf.gz

# get handle for reference file
reference_fasta="$(ggd list-files 'grch37-reference-genome' -s 'Homo_sapiens' -g 'GRCh37' -p 'hs37d5.fa')"

# get the santizer script
wget --quiet https://raw.githubusercontent.com/arq5x/gemini/master/gemini/annotation_provenance/sanitize-esp.py

# sanitize
zless ESP6500SI.all.snps_indels.vcf.gz | python sanitize-esp.py | bgzip -c > temp.gz
tabix temp.gz

# 1st clean up environment
rm ESP6500SI-V2-SSA137.GRCh38-liftover.snps_indels.vcf.tar.gz
rm ESP6500SI-V2-SSA137.GRCh38-liftover.chr*.snps_indels.vcf
rm ESP6500SI.all.snps_indels.vcf.gz.tbi
rm ESP6500SI.all.snps_indels.vcf.gz
rm sanitize-esp.py

# decompose with vt
vt decompose -s temp.gz -o dec_temp.vcf
echo `$reference_fasta`
echo `head $reference_fasta`
vt normalize dec_temp.vcf -r $reference_fasta -o dec_norm_temp.vcf
perl -pe 's/\([EA_|T|AA_]\)AC,Number=R,Type=Integer/\1AC,Number=R,Type=String/' dec_norm_temp.vcf > processed_temp.vcf
bgzip -c processed_temp.vcf > ESP6500SI.all.snps_indels.tidy.vcf.gz

tabix ESP6500SI.all.snps_indels.tidy.vcf.gz


# 2nd clean up environment
rm temp.gz
rm temp.gz.tbi
rm temp.vcf
rm dec_temp.vcf
rm dec_norm_temp.vcf
rm processed_temp.vcf


