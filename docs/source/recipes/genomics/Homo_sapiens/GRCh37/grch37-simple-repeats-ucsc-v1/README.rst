.. _`grch37-simple-repeats-ucsc-v1`:

grch37-simple-repeats-ucsc-v1
=============================

|downloads|

Simple repeats track from UCSC. Simple tandem repeats and imperfect repeats identified by the Tandem Repeats Finder (TRF) algorithm. Any scaffoldings not in the hg19.genome file are removed from the final file. Remapped from UCSC hg19 to Ensembl GRCh37

================================== ====================================
GGD Pacakge                        grch37-simple-repeats-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       22-Mar-2020
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-simple-repeats-ucsc-v1.bed.gz, grch37-simple-repeats-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File grch37-simple-repeats-ucsc-v1.bed.gz: **25.33M**, grch37-simple-repeats-ucsc-v1.bed.gz.tbi: **1.35M**
Package Keywords                   simrep, simple-repeats, repeats, tandem-repeats, simple-tandem-repeats
Package Dependencies:              grch37-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-simple-repeats-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-simple-repeats-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-simple-repeats-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-simple-repeats-ucsc-v1