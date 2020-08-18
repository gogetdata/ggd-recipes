.. _`hg38-autosomal-recessive-genes-blekhman-v1`:

hg38-autosomal-recessive-genes-blekhman-v1
==========================================

|downloads|

CDS region genomic coordinates, along with the compliment coordinates, for OMIM disease genes deemed  to follow autosomal recessive inheritance according to extensive manual curation by Molly Przeworski&#39;s group.(https://www.ncbi.nlm.nih.gov/pubmed/18571414).

================================== ====================================
GGD Pacakge                        hg38-autosomal-recessive-genes-blekhman-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      blekhman
Data Version                       6-24-2008
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg38-autosomal-recessive-genes-blekhman-v1.bed.gz, hg38-autosomal-recessive-genes-blekhman-v1.bed.gz.tbi, hg38-autosomal-recessive-genes-blekhman-v1.compliment.bed.gz, hg38-autosomal-recessive-genes-blekhman-v1.compliment.bed.gz.tbi
Approximate Size of Each Data File hg38-autosomal-recessive-genes-blekhman-v1.bed.gz: **112.99K**, hg38-autosomal-recessive-genes-blekhman-v1.bed.gz.tbi: **23.68K**, hg38-autosomal-recessive-genes-blekhman-v1.compliment.bed.gz: **73.92K**, hg38-autosomal-recessive-genes-blekhman-v1.compliment.bed.gz.tbi: **24.23K**
Package Keywords                   genes, autosomal-recessive, disease, Blekhman_et_al, AR, OMIM, gene_coordinates, CDS-regions
Package Dependencies:              bedtools, grch38-gene-features-ensembl-v1, gsort, hg38-chrom-mapping-ensembl2ucsc-ncbi-v1, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-autosomal-recessive-genes-blekhman-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-autosomal-recessive-genes-blekhman-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-autosomal-recessive-genes-blekhman-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-autosomal-recessive-genes-blekhman-v1