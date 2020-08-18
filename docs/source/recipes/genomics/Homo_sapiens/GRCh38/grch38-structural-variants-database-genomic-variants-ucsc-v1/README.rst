.. _`grch38-structural-variants-database-genomic-variants-ucsc-v1`:

grch38-structural-variants-database-genomic-variants-ucsc-v1
============================================================

|downloads|

Database of Genomic Variants incorporating dbVar, July 2013 and later

================================== ====================================
GGD Pacakge                        grch38-structural-variants-database-genomic-variants-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      jrb 
Data Provider                      UCSC
Data Version                       2020-01-14
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch38-structural-variants-database-genomic-variants-ucsc-v1.bed.gz, grch38-structural-variants-database-genomic-variants-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File grch38-structural-variants-database-genomic-variants-ucsc-v1.bed.gz: **73.35M**, grch38-structural-variants-database-genomic-variants-ucsc-v1.bed.gz.tbi: **216.28K**
Package Keywords                   structural-variants, structural-variant, SVs, SV, dbVar, dbvar
Package Dependencies:              grch38-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-structural-variants-database-genomic-variants-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-structural-variants-database-genomic-variants-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-structural-variants-database-genomic-variants-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-structural-variants-database-genomic-variants-ucsc-v1