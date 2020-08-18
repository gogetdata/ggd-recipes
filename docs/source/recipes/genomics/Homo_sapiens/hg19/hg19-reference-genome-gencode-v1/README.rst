.. _`hg19-reference-genome-gencode-v1`:

hg19-reference-genome-gencode-v1
================================

|downloads|

The GRCh37 DNA nucleotide sequence primary assembly. Sequence regions include reference chromsomes and scaffoldings. Mapped to hg19

================================== ====================================
GGD Pacakge                        hg19-reference-genome-gencode-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      GENCODE
Data Version                       release-34
Genomic File Type                  fa
Data file coordinate basing        NA
Package's Data Files               hg19-reference-genome-gencode-v1.fa.gz, hg19-reference-genome-gencode-v1.fa.gz.fai, hg19-reference-genome-gencode-v1.fa.gz.gzi
Approximate Size of Each Data File hg19-reference-genome-gencode-v1.fa.gz: **881.99M**, hg19-reference-genome-gencode-v1.fa.gz.fai: **2.82K**, hg19-reference-genome-gencode-v1.fa.gz.gzi: **772.92K**
Package Keywords                   Reference-Genome, Fasta, DNA-Sequence, GENCODE-34, Fasta-sequence, primary-assemlby
Package Dependencies:              htslib, samtools, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-reference-genome-gencode-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-reference-genome-gencode-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-reference-genome-gencode-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-reference-genome-gencode-v1