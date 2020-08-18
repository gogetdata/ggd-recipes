.. _`grch37-haploinsufficient-genes-dang-v1`:

grch37-haploinsufficient-genes-dang-v1
======================================

|downloads|

CDS region genomic coordinates, along with complement coordinates, for a set of haploinsufficient genes from Dang et al. (2008): https://www.nature.com/articles/ejhg2008111. They used text-searching and database-mining on Pubmed and OMIM to extract an annotated list of human haploinsufficient genes, their associated diseases, and functions. Any genes in patch regions or non-reference scaffoldings are not included.

================================== ====================================
GGD Pacakge                        grch37-haploinsufficient-genes-dang-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Dang
Data Version                       04-June-2008
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-haploinsufficient-genes-dang-v1.bed.gz, grch37-haploinsufficient-genes-dang-v1.bed.gz.tbi, grch37-haploinsufficient-genes-dang-v1.complement.bed.gz, grch37-haploinsufficient-genes-dang-v1.complement.bed.gz.tbi
Approximate Size of Each Data File grch37-haploinsufficient-genes-dang-v1.bed.gz: **51.37K**, grch37-haploinsufficient-genes-dang-v1.bed.gz.tbi: **15.42K**, grch37-haploinsufficient-genes-dang-v1.complement.bed.gz: **31.55K**, grch37-haploinsufficient-genes-dang-v1.complement.bed.gz.tbi: **14.81K**
Package Keywords                   haploinsufficiency, haploinsufficient, haploinsufficient-genes, genes, Dang, gene-set
Package Dependencies:              bedtools, grch37-gene-features-ensembl-v1, gsort, htslib, pyexcel, pyexcel-xls, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-haploinsufficient-genes-dang-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-haploinsufficient-genes-dang-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-haploinsufficient-genes-dang-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-haploinsufficient-genes-dang-v1