.. _`hg38-reference-genome-ucsc-v1`:

hg38-reference-genome-ucsc-v1
=============================

|downloads|

The hg38 soft masked genomic DNA seqeunce reference genome from UCSC (patch 12). Repeats found by &#39;RepeatMasker&#39; and &#39;Tandem Repeat Finder&#39; are shown as lower case. Non repeating seqeunce are shown as upper case.

================================== ====================================
GGD Pacakge                        hg38-reference-genome-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       10-Aug-2018
Genomic File Type                  fa
Data file coordinate basing        NA
Package's Data Files               hg38-reference-genome-ucsc-v1.fa.gz, hg38-reference-genome-ucsc-v1.fa.gz.fai, hg38-reference-genome-ucsc-v1.fa.gz.gzi
Approximate Size of Each Data File hg38-reference-genome-ucsc-v1.fa.gz: **1.02G**, hg38-reference-genome-ucsc-v1.fa.gz.fai: **25.61K**, hg38-reference-genome-ucsc-v1.fa.gz.gzi: **814.34K**
Package Keywords                   ref, reference-genome, fasta-file, soft-masked
Package Dependencies:              htslib, samtools, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-reference-genome-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-reference-genome-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-reference-genome-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-reference-genome-ucsc-v1