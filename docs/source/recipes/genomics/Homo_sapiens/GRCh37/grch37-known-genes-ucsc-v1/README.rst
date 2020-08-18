.. _`grch37-known-genes-ucsc-v1`:

grch37-known-genes-ucsc-v1
==========================

|downloads|

The &#39;KnownGene&#39; track from UCSC. Comprsied of gene predictions based on data from Refseq, GenBank, CCDS, RFam, and tRNA genes tracks. Includes protein-coding genes and non-coding RNA genes. Gene symbols and gene descriptions have been added to the dataset. Remapped from UCSC hg19 to Ensembl GRCh37

================================== ====================================
GGD Pacakge                        grch37-known-genes-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       30-Jun-2013
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-known-genes-ucsc-v1.bed.gz, grch37-known-genes-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File grch37-known-genes-ucsc-v1.bed.gz: **5.22M**, grch37-known-genes-ucsc-v1.bed.gz.tbi: **129.95K**
Package Keywords                   KnownGenes, gene-features, UCSC-Genes, protein-coding-genes, non-coding-RNA-genes
Package Dependencies:              grch37-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-known-genes-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-known-genes-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-known-genes-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-known-genes-ucsc-v1