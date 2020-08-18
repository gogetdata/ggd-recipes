.. _`hg38-autosomal-dominant-genes-berg-v1`:

hg38-autosomal-dominant-genes-berg-v1
=====================================

|downloads|

CDS region genomic coordinates, along with the compliment coordinates, for OMIM disease genes (as of June 2011) deemed to follow autosomal dominant inheritance. (Assembled by Macarthur Lab). Berg et al, 2013:  (https://www.ncbi.nlm.nih.gov/pubmed/22995991).

================================== ====================================
GGD Pacakge                        hg38-autosomal-dominant-genes-berg-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      berg
Data Version                       1-15-2013
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg38-autosomal-dominant-genes-berg-v1.bed.gz, hg38-autosomal-dominant-genes-berg-v1.bed.gz.tbi, hg38-autosomal-dominant-genes-berg-v1.compliment.bed.gz, hg38-autosomal-dominant-genes-berg-v1.compliment.bed.gz.tbi
Approximate Size of Each Data File hg38-autosomal-dominant-genes-berg-v1.bed.gz: **132.42K**, hg38-autosomal-dominant-genes-berg-v1.bed.gz.tbi: **26.78K**, hg38-autosomal-dominant-genes-berg-v1.compliment.bed.gz: **79.83K**, hg38-autosomal-dominant-genes-berg-v1.compliment.bed.gz.tbi: **25.45K**
Package Keywords                   genes, autosomal-dominant, disease, Berg_et_al, AD, OMIM, gene_coordinates, CDS-regions
Package Dependencies:              bedtools, grch38-gene-features-ensembl-v1, gsort, hg38-chrom-mapping-ensembl2ucsc-ncbi-v1, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-autosomal-dominant-genes-berg-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-autosomal-dominant-genes-berg-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-autosomal-dominant-genes-berg-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-autosomal-dominant-genes-berg-v1