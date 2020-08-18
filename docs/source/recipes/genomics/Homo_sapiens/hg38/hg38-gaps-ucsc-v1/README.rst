.. _`hg38-gaps-ucsc-v1`:

hg38-gaps-ucsc-v1
=================

|downloads|

Assembly gaps from UCSC in bed fromat

================================== ====================================
GGD Pacakge                        hg38-gaps-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       11-Mar-2019
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg38-gaps-ucsc-v1.bed.gz, hg38-gaps-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File hg38-gaps-ucsc-v1.bed.gz: **9.33K**, hg38-gaps-ucsc-v1.bed.gz.tbi: **10.71K**
Package Keywords                   gaps, regions, gap-locations, Assembly-Gaps, clone-gaps, contig-gaps, centromere-gaps, telomere-gaps, heterochromatin-gaps, short-arm-gaps
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-gaps-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-gaps-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-gaps-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-gaps-ucsc-v1