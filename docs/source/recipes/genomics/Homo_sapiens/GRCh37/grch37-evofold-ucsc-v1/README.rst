.. _`grch37-evofold-ucsc-v1`:

grch37-evofold-ucsc-v1
======================

|downloads|

The evolutionary conserved mRNA secondary structure predictions hosted on UCSC. In bed format. Remapped from UCSC hg19 to Ensembl GRCh37

================================== ====================================
GGD Pacakge                        grch37-evofold-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       26-Dec-2010
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-evofold-ucsc-v1.bed.gz, grch37-evofold-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File grch37-evofold-ucsc-v1.bed.gz: **3.20M**, grch37-evofold-ucsc-v1.bed.gz.tbi: **279.01K**
Package Keywords                   mRNA, secondary-structure, evofold, UCSC, conserved, bed-file
Package Dependencies:              grch37-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-evofold-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-evofold-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-evofold-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-evofold-ucsc-v1