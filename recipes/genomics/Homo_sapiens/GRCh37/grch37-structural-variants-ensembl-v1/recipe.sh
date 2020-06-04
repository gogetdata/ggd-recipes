#!/bin/sh
set -eo pipefail -o nounset


cat << EOF > fixed_header.txt 
##fileformat=VCFv4.2
##FILTER=<ID=PASS,Description="All filters passed">
##fileDate=20140210
##source=ensembl;version=74;url=http://e74.ensembl.org/homo_sapiens
##reference=ftp://ftp.ensembl.org/pub/release-74/fasta/homo_sapiens/dna/
##INFO=<ID=Affy GenomeWideSNP_6 CNV,Number=0,Type=Flag,Description="Copy Number Variation (CNV) probes from the Affymetrix Genome-Wide Human SNP Array 6.0">
##INFO=<ID=Illumina_Human660W-quad,Number=0,Type=Flag,Description="Variants from the Illumina Human 660W-Quad whole genome SNP genotyping chip designed for association studies">
##INFO=<ID=Illumina_CytoSNP12v1,Number=0,Type=Flag,Description="Variants from the Illumina Cyto SNP-12 v1 whole genome SNP genotyping chip designed for cytogenetic analysis">
##INFO=<ID=PhenCode,Number=0,Type=Flag,Description="PhenCode is a collaborative project to better understand the relationship between genotype and phenotype in humans">
##INFO=<ID=Illumina_Human1M-duoV3,Number=0,Type=Flag,Description="Variants from the Illumina Human 1M-DuoV3 whole genome SNP genotyping chip designed for association studies">
##INFO=<ID=DGVa_201401,Number=0,Type=Flag,Description="Database of Genomic Variants Archive">
##INFO=<ID=IMPRECISE,Number=0,Type=Flag,Description="Imprecise structural variation">
##INFO=<ID=END,Number=1,Type=Integer,Description="End position of the variant described in this record">
##INFO=<ID=SVTYPE,Number=0,Type=String,Description="Type of structural variant">
##ALT=<ID=CNV:LOSS,Description="copy_number_loss">
##ALT=<ID=DEL,Description="deletion">
##ALT=<ID=INS,Description="insertion">
##ALT=<ID=SA,Description="sequence_alteration">
##ALT=<ID=CSA,Description="complex_structural_alteration">
##ALT=<ID=CNV:GAIN,Description="copy_number_gain">
##ALT=<ID=DUP,Description="duplication">
##ALT=<ID=DUP:TANDEM,Description="tandem_duplication">
##ALT=<ID=CNV,Description="copy_number_variation">
##ALT=<ID=INV,Description="inversion">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
EOF

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

wget --quiet ftp://ftp.ensembl.org/pub/release-75/variation/vcf/homo_sapiens/Homo_sapiens_structural_variations.vcf.gz

## Get the reference genome 
fai_file=$(ggd get-files grch37-reference-genome-ensembl-v1 --pattern "*.fai")
bcftools reheader -h fixed_header.txt  Homo_sapiens_structural_variations.vcf.gz > Homo_sapiens_structural_variations_fixed.vcf 
bcftools reheader --fai $fai_file  Homo_sapiens_structural_variations_fixed.vcf > Homo_sapiens_structural_variations_fixed_with_contigs.vcf 


gsort Homo_sapiens_structural_variations_fixed_with_contigs.vcf $genome \
    | bgzip -c > grch37-structural-variants-ensembl-v1.vcf.gz

tabix grch37-structural-variants-ensembl-v1.vcf.gz

rm Homo_sapiens_structural_variations.vcf.gz
rm Homo_sapiens_structural_variations_fixed.vcf
rm Homo_sapiens_structural_variations_fixed_with_contigs.vcf
rm fixed_header.txt
