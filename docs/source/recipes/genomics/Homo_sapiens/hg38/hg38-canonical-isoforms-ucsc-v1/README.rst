.. _`hg38-canonical-isoforms-ucsc-v1`:

hg38-canonical-isoforms-ucsc-v1
===============================

|downloads|

The Canonical Isofrom for each gene (or cluster) from UCSC. The APPRIS principal transcripts are used to define the canonical transcripts. If APPRIS filtering results in no transcripts, the longest isofrom is selected.

================================== ====================================
GGD Pacakge                        hg38-canonical-isoforms-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       13-Oct-2019
Genomic File Type                  bed
Data file coordinate basing        0-based-exclusive
Package's Data Files               hg38-canonical-isoforms-ucsc-v1.bed.gz, hg38-canonical-isoforms-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File hg38-canonical-isoforms-ucsc-v1.bed.gz: **1.55M**, hg38-canonical-isoforms-ucsc-v1.bed.gz.tbi: **201.44K**
Package Keywords                   Canonical, Isofrom, Canonical-Isoform, KnownCanonical, APPRIS, APPRIS-Principal-Transcript, Canonical-Transcript, Transcript
Package Dependencies:              gsort, hg38-known-genes-ucsc-v1, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-canonical-isoforms-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-canonical-isoforms-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-canonical-isoforms-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-canonical-isoforms-ucsc-v1