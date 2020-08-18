.. _`hg19-segmental-dups-ucsc-v1`:

hg19-segmental-dups-ucsc-v1
===========================

|downloads|

The hg19 segmental duplications (SuperDups) File from UCSC. That is, duplications of at least 1kb total sequence of non-repeatmasker sequence in bed format

================================== ====================================
GGD Pacakge                        hg19-segmental-dups-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       25-Oct-2011
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg19-segmental-dups-ucsc-v1.bed.gz, hg19-segmental-dups-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File hg19-segmental-dups-ucsc-v1.bed.gz: **2.96M**, hg19-segmental-dups-ucsc-v1.bed.gz.tbi: **77.69K**
Package Keywords                   superdups, segdups, seg, dups, duplications, UCSC, Segmental-Duplication
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-segmental-dups-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-segmental-dups-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-segmental-dups-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-segmental-dups-ucsc-v1