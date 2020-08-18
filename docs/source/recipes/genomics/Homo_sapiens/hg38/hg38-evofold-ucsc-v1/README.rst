.. _`hg38-evofold-ucsc-v1`:

hg38-evofold-ucsc-v1
====================

|downloads|

*Liftover* The evolutionary conserved mRNA secondary structure predictions hosted on UCSC. In bed format. Lifted over from UCSC hg19 to UCSC hg38.

================================== ====================================
GGD Pacakge                        hg38-evofold-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       26-Dec-2010
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg38-evofold-ucsc-v1.bed.gz, hg38-evofold-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File hg38-evofold-ucsc-v1.bed.gz: **3.21M**, hg38-evofold-ucsc-v1.bed.gz.tbi: **277.97K**
Package Keywords                   mRNA, secondary-structure, evofold, UCSC, conserved, bed-file
Package Dependencies:              crossmap, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-evofold-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-evofold-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-evofold-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-evofold-ucsc-v1