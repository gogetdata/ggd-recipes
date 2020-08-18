.. _`grch38-structural-variants-ensembl-v1`:

grch38-structural-variants-ensembl-v1
=====================================

|downloads|

All known structural mutations at the time of Ensembl release 99. Remapped from Ensembl GRCh38 to UCSC hg38. Ensembl variant info page can be found at: https://uswest.ensembl.org/info/genome/variation/index.html

================================== ====================================
GGD Pacakge                        grch38-structural-variants-ensembl-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Ensembl
Data Version                       release-99_11-7-19
Genomic File Type                  vcf
Data file coordinate basing        1-based-inclusive
Package's Data Files               grch38-structural-variants-ensembl-v1.vcf.gz, grch38-structural-variants-ensembl-v1.vcf.gz.tbi
Approximate Size of Each Data File grch38-structural-variants-ensembl-v1.vcf.gz: **225.68M**, grch38-structural-variants-ensembl-v1.vcf.gz.tbi: **270.65K**
Package Keywords                   genetic-varaition, SV, structural-mutations, structural-variants, VCF, varaint-info, Ensembl-variantion
Package Dependencies:              bcftools, grch38-reference-genome-ensembl-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-structural-variants-ensembl-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-structural-variants-ensembl-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-structural-variants-ensembl-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-structural-variants-ensembl-v1