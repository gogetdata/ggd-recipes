.. _`hg19-heart-genes-sifrim-v1`:

hg19-heart-genes-sifrim-v1
==========================

|downloads|

CDS region genomic coordinates, along with complement coordinates, for a manually curated set of congenital heart disease (CHD) genes from Sifrim et al. (www.nature.com/articles/ng.3627). Used Supplemental Table 20 here: https://media.nature.com/original/nature-assets/ng/journal/v48/n9/extref/ng.3627-S13.xlsx

================================== ====================================
GGD Pacakge                        hg19-heart-genes-sifrim-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Sifrim
Data Version                       01-Aug-2016
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg19-heart-genes-sifrim-v1.bed.gz, hg19-heart-genes-sifrim-v1.bed.gz.tbi, hg19-heart-genes-sifrim-v1.complement.bed.gz, hg19-heart-genes-sifrim-v1.complement.bed.gz.tbi
Approximate Size of Each Data File hg19-heart-genes-sifrim-v1.bed.gz: **39.09K**, hg19-heart-genes-sifrim-v1.bed.gz.tbi: **12.42K**, hg19-heart-genes-sifrim-v1.complement.bed.gz: **26.38K**, hg19-heart-genes-sifrim-v1.complement.bed.gz.tbi: **10.07K**
Package Keywords                   heart, heart-disease, heart-genes, genes, sifrim, gene-set
Package Dependencies:              bedtools, grch37-gene-features-ensembl-v1, gsort, hg19-chrom-mapping-ensembl2ucsc-ncbi-v1, htslib, pyexcel, pyexcel-xls, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-heart-genes-sifrim-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-heart-genes-sifrim-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-heart-genes-sifrim-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-heart-genes-sifrim-v1