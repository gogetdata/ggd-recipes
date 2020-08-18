.. _`hg19-knowngene-gene-features-ucsc-v1`:

hg19-knowngene-gene-features-ucsc-v1
====================================

|downloads|

Gene features from the &#39;KnownGene&#39; track from UCSC. (GTF). Features include 5UTR, 3UTR, CDS, exon, start_codon, stop_codon, transcript. Features are comprised of gene predictions based on data from Refseq, GenBank, CCDS, RFam, and tRNA genes tracks. IDs correspond to the UCSC knowGene IDs

================================== ====================================
GGD Pacakge                        hg19-knowngene-gene-features-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       10-Jan-2020
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               hg19-knowngene-gene-features-ucsc-v1.gtf.gz, hg19-knowngene-gene-features-ucsc-v1.gtf.gz.tbi
Approximate Size of Each Data File hg19-knowngene-gene-features-ucsc-v1.gtf.gz: **17.42M**, hg19-knowngene-gene-features-ucsc-v1.gtf.gz.tbi: **282.43K**
Package Keywords                   KnownGenes, gene-features, UCSC-Genes, feature-file, gene-feature-file, 5UTR, 3UTR, CDS, exon, start_codon, stop_codon, transcript, GTF
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-knowngene-gene-features-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-knowngene-gene-features-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-knowngene-gene-features-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-knowngene-gene-features-ucsc-v1