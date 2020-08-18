.. _`hg38-structural-variants-gnomad-ncbi-v1`:

hg38-structural-variants-gnomad-ncbi-v1
=======================================

|downloads|

SV callset 2.1 from gnomAD, lifted over to build 38 in NCBI. Remapped from Ensembl GRCh38 to UCSC hg38

================================== ====================================
GGD Pacakge                        hg38-structural-variants-gnomad-ncbi-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      jrb 
Data Provider                      NCBI
Data Version                       2.1
Genomic File Type                  vcf
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg38-structural-variants-gnomad-ncbi-v1.hg38.sites.vcf.gz, hg38-structural-variants-gnomad-ncbi-v1.hg38.sites.vcf.gz.tbi
Approximate Size of Each Data File hg38-structural-variants-gnomad-ncbi-v1.hg38.sites.vcf.gz: **12.03M**, hg38-structural-variants-gnomad-ncbi-v1.hg38.sites.vcf.gz.tbi: **399.53K**
Package Keywords                   sv, gnomAD, structural-variants, vcf-file, liftover, ncbi
Package Dependencies:              gsort, hg38-chrom-mapping-ensembl2ucsc-ncbi-v1, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-structural-variants-gnomad-ncbi-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-structural-variants-gnomad-ncbi-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-structural-variants-gnomad-ncbi-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-structural-variants-gnomad-ncbi-v1