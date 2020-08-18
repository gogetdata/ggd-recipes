.. _`grch37-chrom-mapping-ucsc2refseq-ncbi-v1`:

grch37-chrom-mapping-ucsc2refseq-ncbi-v1
========================================

|downloads|

A tab delimited file containing scaffolding ids that maps hg19 UCSC scaffoldings to GRCh37 RefSeq scaffoldings. This is specific to patch 13 of the GRCh37 Human genome build. (1st column = UCSC ids, 2nd column = RefSeq ids)

================================== ====================================
GGD Pacakge                        grch37-chrom-mapping-ucsc2refseq-ncbi-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      NCBI
Data Version                       12-October-2016-(patch13)
Genomic File Type                  txt
Data file coordinate basing        NA
Package's Data Files               grch37-chrom-mapping-ucsc2refseq-ncbi-v1.txt
Approximate Size of Each Data File grch37-chrom-mapping-ucsc2refseq-ncbi-v1.txt: **2.43K**
Package Keywords                   Chromosome-mapping, mapping, chrommapping, UCSC2RefSeq, scaffolding-ids, txt, patch-13, hg19-to-GRCh37
Package Dependencies:              bioawk
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-chrom-mapping-ucsc2refseq-ncbi-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-chrom-mapping-ucsc2refseq-ncbi-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-chrom-mapping-ucsc2refseq-ncbi-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-chrom-mapping-ucsc2refseq-ncbi-v1