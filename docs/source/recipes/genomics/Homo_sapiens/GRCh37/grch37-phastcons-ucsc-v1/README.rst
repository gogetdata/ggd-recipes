.. _`grch37-phastcons-ucsc-v1`:

grch37-phastcons-ucsc-v1
========================

|downloads|

Conservation scores based on the phastcons HMM algorithm against multi-aligned sequences of 100 different species. Remapped from UCSC hg19 to Ensembl GRCh37.

================================== ====================================
GGD Pacakge                        grch37-phastcons-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       09-Feb-2014
Genomic File Type                  bedGraph.gz, bedGraph.gz.tbi, bw
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-phastcons-ucsc-v1.bedGraph.bw, grch37-phastcons-ucsc-v1.bedGraph.gz, grch37-phastcons-ucsc-v1.bedGraph.gz.tbi
Approximate Size of Each Data File grch37-phastcons-ucsc-v1.bedGraph.bw: **13.41G**, grch37-phastcons-ucsc-v1.bedGraph.gz: **11.65G**, grch37-phastcons-ucsc-v1.bedGraph.gz.tbi: **1.93K**
Package Keywords                   phastCons, conservation, phastCons-Hmm, conservation-scores, genome-conservation, bigwig, bedgraph
Package Dependencies:              gsort, htslib, ucsc-bigwigtobedgraph, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-phastcons-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-phastcons-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-phastcons-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-phastcons-ucsc-v1