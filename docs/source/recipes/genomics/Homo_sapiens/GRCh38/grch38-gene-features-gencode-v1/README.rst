.. _`grch38-gene-features-gencode-v1`:

grch38-gene-features-gencode-v1
===============================

|downloads|

Comprehensive set of gene anntotations including reference chromosomes, scaffoldings, assebly patches, and alternative loci. Data is specific to GENCODE Release 34 (Ensembl 100). Features include: gene, transcript, exon, CDS, UTR, start_codon, stop_codon, and Selenocysteine.

================================== ====================================
GGD Pacakge                        grch38-gene-features-gencode-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      GENCODE
Data Version                       release-34_03-24-2020
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               grch38-gene-features-gencode-v1.gtf.gz, grch38-gene-features-gencode-v1.gtf.gz.tbi
Approximate Size of Each Data File grch38-gene-features-gencode-v1.gtf.gz: **60.52M**, grch38-gene-features-gencode-v1.gtf.gz.tbi: **367.33K**
Package Keywords                   Gene-Features, Gene-Annotations, All-Regions, GTF, GENOCDOE-GTF, GENCODE-Gene-Sets, Annotated-Transcripts
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-gene-features-gencode-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-gene-features-gencode-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-gene-features-gencode-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-gene-features-gencode-v1