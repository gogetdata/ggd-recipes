.. _`grch38-autosomal-dominant-genes-blekhman-v1`:

grch38-autosomal-dominant-genes-blekhman-v1
===========================================

|downloads|

CDS region genomic coordinates, along with the compliment coordinates, for OMIM disease genes deemed  to follow autosomal dominant inheritance according to extensive manual curation by Molly Przeworski&#39;s group.(https://www.ncbi.nlm.nih.gov/pubmed/18571414).

================================== ====================================
GGD Pacakge                        grch38-autosomal-dominant-genes-blekhman-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      blekhman
Data Version                       6-24-2008
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch38-autosomal-dominant-genes-blekhman-v1.bed.gz, grch38-autosomal-dominant-genes-blekhman-v1.bed.gz.tbi, grch38-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz, grch38-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz.tbi
Approximate Size of Each Data File grch38-autosomal-dominant-genes-blekhman-v1.bed.gz: **64.42K**, grch38-autosomal-dominant-genes-blekhman-v1.bed.gz.tbi: **14.98K**, grch38-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz: **41.05K**, grch38-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz.tbi: **20.92K**
Package Keywords                   genes, autosomal-dominant, disease, Blekhman_et_al, AD, OMIM, gene_coordinates, CDS-regions
Package Dependencies:              bedtools, grch38-gene-features-ensembl-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-autosomal-dominant-genes-blekhman-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-autosomal-dominant-genes-blekhman-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-autosomal-dominant-genes-blekhman-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-autosomal-dominant-genes-blekhman-v1