.. _`hg19-haploinsufficient-genes-dang-v1`:

hg19-haploinsufficient-genes-dang-v1
====================================

|downloads|

CDS region genomic coordinates, along with complement coordinates, for a set of haploinsufficient genes from Dang et al. (2008): https://www.nature.com/articles/ejhg2008111. They used text-searching and database-mining on Pubmed and OMIM to extract an annotated list of human haploinsufficient genes, their associated diseases, and functions. Any genes in patch regions or non-reference scaffoldings are not included.

================================== ====================================
GGD Pacakge                        hg19-haploinsufficient-genes-dang-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Dang
Data Version                       04-June-2008
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg19-haploinsufficient-genes-dang-v1.bed.gz, hg19-haploinsufficient-genes-dang-v1.bed.gz.tbi, hg19-haploinsufficient-genes-dang-v1.complement.bed.gz, hg19-haploinsufficient-genes-dang-v1.complement.bed.gz.tbi
Approximate Size of Each Data File hg19-haploinsufficient-genes-dang-v1.bed.gz: **51.60K**, hg19-haploinsufficient-genes-dang-v1.bed.gz.tbi: **15.41K**, hg19-haploinsufficient-genes-dang-v1.complement.bed.gz: **31.81K**, hg19-haploinsufficient-genes-dang-v1.complement.bed.gz.tbi: **11.21K**
Package Keywords                   haploinsufficiency, haploinsufficient, haploinsufficient-genes, genes, Dang, gene-set
Package Dependencies:              bedtools, grch37-gene-features-ensembl-v1, gsort, hg19-chrom-mapping-ensembl2ucsc-ncbi-v1, htslib, pyexcel, pyexcel-xls, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-haploinsufficient-genes-dang-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-haploinsufficient-genes-dang-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-haploinsufficient-genes-dang-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-haploinsufficient-genes-dang-v1