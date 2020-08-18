.. _`grch38-known-genes-ucsc-v1`:

grch38-known-genes-ucsc-v1
==========================

|downloads|

The &#39;KnownGene&#39; track from UCSC. Comprised of all gene models from GENCODE v32. Includes protein-coding genes, non-coding RNA genes, and pseudo-genes. Gene symbols and gene descriptions have been added to the dataset. Remapped from UCSC hg38 to Ensembl GRCh38

================================== ====================================
GGD Pacakge                        grch38-known-genes-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       13-Oct-2019
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch38-known-genes-ucsc-v1.bed.gz, grch38-known-genes-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File grch38-known-genes-ucsc-v1.bed.gz: **13.64M**, grch38-known-genes-ucsc-v1.bed.gz.tbi: **217.99K**
Package Keywords                   KnownGenes, gene-features, UCSC-Genes, protein-coding-genes, non-coding-RNA-genes, long-non-coding-RNA, small-non-coding-RNA, pseduogenes, immunoglobulin, GENCODE-v32-genes
Package Dependencies:              grch38-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-known-genes-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-known-genes-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-known-genes-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-known-genes-ucsc-v1