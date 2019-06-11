#!/bin/sh
set -eo pipefail -o nounset
#!/bin/bash

set -euo pipefail

#Get the latest CIViC files
echo "Retrieving the latest data downloads from CIViC"
curl -o nightly-VariantSummaries.tsv -L https://civicdb.org/downloads/nightly/nightly-VariantSummaries.tsv
curl -o nightly-GeneSummaries.tsv -L https://civicdb.org/downloads/nightly/nightly-GeneSummaries.tsv
curl -o nightly-ClinicalEvidenceSummaries.tsv -L https://civicdb.org/downloads/nightly/nightly-ClinicalEvidenceSummaries.tsv

#Get resource files that will be needed
echo "Downloading coordinate and abbraviation files"
curl -o sorted.ensembl.gene.coords -L https://github.com/fakedrtom/cancer_annotations/raw/master/sorted.ensembl.gene.coords
curl -o cancer_names_abbreviations.txt -L https://github.com/fakedrtom/cancer_annotations/raw/master/cancer_names_abbreviations.txt
curl -o GRCh37.genome -L https://github.com/gogetdata/ggd-recipes/raw/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

#Merge CIViC files into civic_variants, civic_genes, and civic_genes_summaries bed files
echo "Creating civic_genes, civic_gene_summaries, and civic_variants BED files"
curl -o merge_civic_files.py -L https://github.com/fakedrtom/cancer_annotations/raw/master/civic/merge_civic_files.py
python merge_civic_files.py nightly-ClinicalEvidenceSummaries.tsv nightly-VariantSummaries.tsv nightly-GeneSummaries.tsv sorted.ensembl.gene.coords
curl -o summarize_civic_gene.py -L https://github.com/fakedrtom/cancer_annotations/raw/master/civic/summarize_civic_gene.py
python summarize_civic_gene.py tmp.civic_genes.bed cancer_names_abbreviations.txt
curl -o summarize_civic_variant.py -L https://github.com/fakedrtom/cancer_annotations/raw/master/civic/summarize_civic_variant.py
python summarize_civic_variant.py tmp.civic_variants.bed cancer_names_abbreviations.txt

#Using gsort, sort and bgzip the bed files, remove the extra, non-gzipped copy of the file
echo "Sorted and gzipping the BED files"
gsort civic_variants_summaries.bed GRCh37.genome | bgzip -c > civic_variants_summaries.bed.gz
rm -r -f civic_variants_summaries.bed
gsort civic_genes_summaries.bed GRCh37.genome | bgzip -c > civic_genes_summaries.bed.gz
rm -r -f civic_genes_summaries.bed

#Create an index, using tabix, of the zipped bed files
echo "Creating tabix indices of the BED files"
tabix -p bed civic_variants_summaries.bed.gz
tabix -p bed civic_genes_summaries.bed.gz

#Remove extra files
rm -r -f nightly-VariantSummaries.tsv
rm -r -f nightly-GeneSummaries.tsv
rm -r -f nightly-ClinicalEvidenceSummaries.tsv
rm -r -f sorted.ensembl.gene.coords
rm -r -f cancer_names_abbreviations.txt
rm -r -f tmp.civic_genes.bed
rm -r -f tmp.civic_variants.bed
rm -r -f GRCh37.genome
rm -r -f merge_civic_files.py
rm -r -f summarize_civic_gene.py
rm -r -f summarize_civic_variant.py
