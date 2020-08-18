.. _`hg38-missense-z-score-exac-v1`:

hg38-missense-z-score-exac-v1
=============================

|downloads|

Missense Z Score by gene. A constraint score based on missense variation, from Samocha et al., Nature Genetics 2014. The score is derived by calculating a null expectation of missense variation for each gene, and comparing it to what is observed in ExAC, then stratifying each gene using a Z score distribution. That paper is at: https://www.nature.com/articles/ng.3050. Pseudo-liftover: Updated coordinates based on transcript ids that map between GRCh37 and GRCh38. If unable to map transcript id, the gene symbol is mapped between GRCh37 and GRCh38. If neither the transcript id or gene symbol map between the two builds the record is removed. Remapped from Ensembl GRCh38 to UCSC hg38

================================== ====================================
GGD Pacakge                        hg38-missense-z-score-exac-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      ExAC
Data Version                       Aug-31-2017
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg38-missense-z-score-exac-v1.bed.gz, hg38-missense-z-score-exac-v1.bed.gz.tbi
Approximate Size of Each Data File hg38-missense-z-score-exac-v1.bed.gz: **530.52K**, hg38-missense-z-score-exac-v1.bed.gz.tbi: **64.77K**
Package Keywords                   Constraint, Missense-Z, ExAC, Z-score, missense-variation, gene-constraint
Package Dependencies:              grch38-gene-features-ensembl-v1, gsort, hg38-chrom-mapping-ensembl2ucsc-ncbi-v1, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-missense-z-score-exac-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-missense-z-score-exac-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-missense-z-score-exac-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-missense-z-score-exac-v1