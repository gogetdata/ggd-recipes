.. _`hg19-cpg-islands-ucsc-v1`:

hg19-cpg-islands-ucsc-v1
========================

|downloads|

cpg islands from UCSC in bed format. Scaffoldings that are not contained in the hg19.genome file are removed

================================== ====================================
GGD Pacakge                        hg19-cpg-islands-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       22-Mar-2020
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg19-cpg-islands-ucsc-v1.bed.gz, hg19-cpg-islands-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File hg19-cpg-islands-ucsc-v1.bed.gz: **621.35K**, hg19-cpg-islands-ucsc-v1.bed.gz.tbi: **186.06K**
Package Keywords                   CpG, region, bed-file, cpg-islands, islands
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-cpg-islands-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-cpg-islands-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-cpg-islands-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-cpg-islands-ucsc-v1