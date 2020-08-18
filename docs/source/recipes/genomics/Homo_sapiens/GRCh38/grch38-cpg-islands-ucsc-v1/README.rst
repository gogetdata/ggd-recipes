.. _`grch38-cpg-islands-ucsc-v1`:

grch38-cpg-islands-ucsc-v1
==========================

|downloads|

cpg islands from UCSC in bed format. Remapped from UCSC hg38 to Ensembl GRCh38. Scaffoldings that cannot remap are removed.

================================== ====================================
GGD Pacakge                        grch38-cpg-islands-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       11-Mar-2019
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch38-cpg-islands-ucsc-v1.bed.gz, grch38-cpg-islands-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File grch38-cpg-islands-ucsc-v1.bed.gz: **663.42K**, grch38-cpg-islands-ucsc-v1.bed.gz.tbi: **201.53K**
Package Keywords                   CpG, region, bed-file, cpg-islands, islands
Package Dependencies:              grch38-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-cpg-islands-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-cpg-islands-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-cpg-islands-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-cpg-islands-ucsc-v1