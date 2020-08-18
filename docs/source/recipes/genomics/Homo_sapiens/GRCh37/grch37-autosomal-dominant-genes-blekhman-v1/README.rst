.. _`grch37-autosomal-dominant-genes-blekhman-v1`:

grch37-autosomal-dominant-genes-blekhman-v1
===========================================

|downloads|

CDS region genomic coordinates, along with the compliment coordinates, for OMIM disease genes deemed  to follow autosomal dominant inheritance according to extensive manual curation by Molly Przeworski&#39;s group.(https://www.ncbi.nlm.nih.gov/pubmed/18571414).

================================== ====================================
GGD Pacakge                        grch37-autosomal-dominant-genes-blekhman-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      blekhman
Data Version                       6-24-2008
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-autosomal-dominant-genes-blekhman-v1.bed.gz, grch37-autosomal-dominant-genes-blekhman-v1.bed.gz.tbi, grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz, grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz.tbi
Approximate Size of Each Data File grch37-autosomal-dominant-genes-blekhman-v1.bed.gz: **59.94K**, grch37-autosomal-dominant-genes-blekhman-v1.bed.gz.tbi: **15.15K**, grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz: **38.45K**, grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz.tbi: **15.37K**
Package Keywords                   genes, autosomal-dominant, disease, Blekhman_et_al, AD, OMIM, gene_coordinates, CDS-regions
Package Dependencies:              bedtools, grch37-gene-features-ensembl-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-autosomal-dominant-genes-blekhman-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-autosomal-dominant-genes-blekhman-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-autosomal-dominant-genes-blekhman-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-autosomal-dominant-genes-blekhman-v1