.. _`hg19-chrom-mapping-ensembl2ucsc-ncbi-v1`:

hg19-chrom-mapping-ensembl2ucsc-ncbi-v1
=======================================

|downloads|

A tab delimited file containing scaffolding ids that maps GRCh37 Ensembl(GenBank) scaffoldings to hg19 UCSC scaffoldings. This is specific to patch 13 of the GRCh37 Human genome build. (1st column = Ensembl ids, 2nd column = UCSC ids)

================================== ====================================
GGD Pacakge                        hg19-chrom-mapping-ensembl2ucsc-ncbi-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      NCBI
Data Version                       12-October-2016-(patch13)
Genomic File Type                  txt
Data file coordinate basing        NA
Package's Data Files               hg19-chrom-mapping-ensembl2ucsc-ncbi-v1.txt
Approximate Size of Each Data File hg19-chrom-mapping-ensembl2ucsc-ncbi-v1.txt: **4.56K**
Package Keywords                   Chromosome-mapping, mapping, chrommapping, Ensembl2UCSC, scaffolding-ids, txt, patch-13, GRCh37-to-hg19
Package Dependencies:              bioawk
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-chrom-mapping-ensembl2ucsc-ncbi-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-chrom-mapping-ensembl2ucsc-ncbi-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-chrom-mapping-ensembl2ucsc-ncbi-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-chrom-mapping-ensembl2ucsc-ncbi-v1