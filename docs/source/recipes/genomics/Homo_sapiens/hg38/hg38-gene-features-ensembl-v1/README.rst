.. _`hg38-gene-features-ensembl-v1`:

hg38-gene-features-ensembl-v1
=============================

|downloads|

Gene features, including all annotated transcripts, that make up the Ensembl gene sets. (Alignment based annotation using proteins, cDNA, RNA-seq, etc.). Features are in GTF format. Remapped from Ensembl GRCh38 to UCSC hg38

================================== ====================================
GGD Pacakge                        hg38-gene-features-ensembl-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Ensembl
Data Version                       release-99_11-21-19
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               hg38-gene-features-ensembl-v1.gtf.gz, hg38-gene-features-ensembl-v1.gtf.gz.tbi
Approximate Size of Each Data File hg38-gene-features-ensembl-v1.gtf.gz: **57.28M**, hg38-gene-features-ensembl-v1.gtf.gz.tbi: **333.87K**
Package Keywords                   Gene-Features, GTF, Ensembl-GTF, Ensembl-Gene-Sets, Annotated-Transcripts
Package Dependencies:              gsort, hg38-chrom-mapping-ensembl2ucsc-ncbi-v1, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-gene-features-ensembl-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-gene-features-ensembl-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-gene-features-ensembl-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-gene-features-ensembl-v1