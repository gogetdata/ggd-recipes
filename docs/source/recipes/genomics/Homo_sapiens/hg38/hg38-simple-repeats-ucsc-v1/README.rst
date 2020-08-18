.. _`hg38-simple-repeats-ucsc-v1`:

hg38-simple-repeats-ucsc-v1
===========================

|downloads|

Simple repeats track from UCSC. Simple tandem repeats and imperfect repeats identified by the Tandem Repeats Finder (TRF) algorithm.

================================== ====================================
GGD Pacakge                        hg38-simple-repeats-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       11-Mar-2019
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg38-simple-repeats-ucsc-v1.bed.gz, hg38-simple-repeats-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File hg38-simple-repeats-ucsc-v1.bed.gz: **27.67M**, hg38-simple-repeats-ucsc-v1.bed.gz.tbi: **1.40M**
Package Keywords                   simrep, simple-repeats, repeats, tandem-repeats, simple-tandem-repeats
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-simple-repeats-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-simple-repeats-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-simple-repeats-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-simple-repeats-ucsc-v1