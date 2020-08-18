.. _`hg19-canonical-isoforms-ucsc-v1`:

hg19-canonical-isoforms-ucsc-v1
===============================

|downloads|

UCSC defined Canonical Isoform for each gene (or cluster). This tends to be the longest isoform.

================================== ====================================
GGD Pacakge                        hg19-canonical-isoforms-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       30-Jun-2013
Genomic File Type                  bed
Data file coordinate basing        0-based-exclusive
Package's Data Files               hg19-canonical-isoforms-ucsc-v1.bed.gz, hg19-canonical-isoforms-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File hg19-canonical-isoforms-ucsc-v1.bed.gz: **899.68K**, hg19-canonical-isoforms-ucsc-v1.bed.gz.tbi: **105.74K**
Package Keywords                   Canonical, Isofrom, Canonical-Isoform, KnownCanonical
Package Dependencies:              gsort, hg19-known-genes-ucsc-v1, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-canonical-isoforms-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-canonical-isoforms-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-canonical-isoforms-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-canonical-isoforms-ucsc-v1