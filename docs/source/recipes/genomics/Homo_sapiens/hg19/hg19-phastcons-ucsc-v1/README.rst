.. _`hg19-phastcons-ucsc-v1`:

hg19-phastcons-ucsc-v1
======================

|downloads|

Conservation scores based on the phastcons HMM algorithm against multi-aligned sequences of 100 different species

================================== ====================================
GGD Pacakge                        hg19-phastcons-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       09-Feb-2014
Genomic File Type                  bedGraph.gz, bedGraph.gz.tbi, bw
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg19-phastcons-ucsc-v1.bedGraph.gz, hg19-phastcons-ucsc-v1.bedGraph.gz.tbi, hg19-phastcons-ucsc-v1.bw
Approximate Size of Each Data File hg19-phastcons-ucsc-v1.bedGraph.gz: **11.75G**, hg19-phastcons-ucsc-v1.bedGraph.gz.tbi: **2.08K**, hg19-phastcons-ucsc-v1.bw: **5.78G**
Package Keywords                   phastCons, conservation, phastCons-Hmm, conservation-scores, genome-conservation, bigwig, bedgraph
Package Dependencies:              gsort, htslib, ucsc-bigwigtobedgraph, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-phastcons-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-phastcons-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-phastcons-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-phastcons-ucsc-v1