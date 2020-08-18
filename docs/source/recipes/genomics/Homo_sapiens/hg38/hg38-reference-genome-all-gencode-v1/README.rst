.. _`hg38-reference-genome-all-gencode-v1`:

hg38-reference-genome-all-gencode-v1
====================================

|downloads|

Genome sequence. Nucleotide sequence of the hg38.p13 genome assembly version on all regions, including reference chromosomes, scaffolds, assembly patches and haplotypes

================================== ====================================
GGD Pacakge                        hg38-reference-genome-all-gencode-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      jrb 
Data Provider                      GENCODE
Data Version                       release-34,patch-13
Genomic File Type                  fa
Data file coordinate basing        NA
Package's Data Files               hg38-reference-genome-all-gencode-v1.fa.gz, hg38-reference-genome-all-gencode-v1.fa.gz.fai, hg38-reference-genome-all-gencode-v1.fa.gz.gzi
Approximate Size of Each Data File hg38-reference-genome-all-gencode-v1.fa.gz: **942.24M**, hg38-reference-genome-all-gencode-v1.fa.gz.fai: **22.03K**, hg38-reference-genome-all-gencode-v1.fa.gz.gzi: **814.12K**
Package Keywords                   reference, all-assembly, gencode, fasta
Package Dependencies:              htslib, samtools, samtools>=1.10, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-reference-genome-all-gencode-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-reference-genome-all-gencode-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-reference-genome-all-gencode-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-reference-genome-all-gencode-v1