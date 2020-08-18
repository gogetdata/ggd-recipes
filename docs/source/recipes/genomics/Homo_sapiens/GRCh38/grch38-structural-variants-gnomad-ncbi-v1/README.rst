.. _`grch38-structural-variants-gnomad-ncbi-v1`:

grch38-structural-variants-gnomad-ncbi-v1
=========================================

|downloads|

SV callset 2.1 from gnomAD, lifted over to build 38 in NCBI

================================== ====================================
GGD Pacakge                        grch38-structural-variants-gnomad-ncbi-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      jrb 
Data Provider                      NCBI
Data Version                       2.1
Genomic File Type                  vcf
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch38-structural-variants-gnomad-ncbi-v1.sites.vcf.gz, grch38-structural-variants-gnomad-ncbi-v1.sites.vcf.gz.tbi
Approximate Size of Each Data File grch38-structural-variants-gnomad-ncbi-v1.sites.vcf.gz: **12.01M**, grch38-structural-variants-gnomad-ncbi-v1.sites.vcf.gz.tbi: **399.29K**
Package Keywords                   sv, gnomAD, structural-variants, vcf-file, liftover, ncbi
Package Dependencies:              grch38-chrom-mapping-refseq2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-structural-variants-gnomad-ncbi-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-structural-variants-gnomad-ncbi-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-structural-variants-gnomad-ncbi-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-structural-variants-gnomad-ncbi-v1