.. _`grch38-phastcons-ucsc-v1`:

grch38-phastcons-ucsc-v1
========================

|downloads|

Conservation scores based on the phastcons HMM algorithm against multi-aligned sequences of 100 different species. Remapped from UCSC hg38 to Ensembl GRCh38

================================== ====================================
GGD Pacakge                        grch38-phastcons-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       08-May-2015
Genomic File Type                  bedGraph.gz, bedGraph.gz.tbi, bw
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch38-phastcons-ucsc-v1.bedGraph.bw, grch38-phastcons-ucsc-v1.bedGraph.gz, grch38-phastcons-ucsc-v1.bedGraph.gz.tbi
Approximate Size of Each Data File grch38-phastcons-ucsc-v1.bedGraph.bw: **13.67G**, grch38-phastcons-ucsc-v1.bedGraph.gz: **11.86G**, grch38-phastcons-ucsc-v1.bedGraph.gz.tbi: **7.11K**
Package Keywords                   phastCons, conservation, phastCons-Hmm, conservation-scores, genome-conservation, bigwig, bedgraph
Package Dependencies:              gsort, htslib, ucsc-bigwigtobedgraph, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-phastcons-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-phastcons-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-phastcons-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-phastcons-ucsc-v1