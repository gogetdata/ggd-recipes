.. _`grch38-canonical-transcript-features-ensembl-v1`:

grch38-canonical-transcript-features-ensembl-v1
===============================================

|downloads|

Gene features from Ensembl Release-100 for protein-coding canonical transcripts based on the APPRIS transcript annotations. Features include gene, transcript, CDS, five_prime_utr, three_prime_utr, exon, start_codon, and stop_codon for all canonical transcripts. Canonical transcripts are determined based on APPRIS annotations. In short, for all protein coding transcripts, transcripts are filtered based on APPRIS isoform flags. If multiple transcripts of the same gene have equal flags, the isoform with the most exons is chosen. If all transcritps for a gene annotated by APPRIS are missing from the base gtf file no canonical transcript is chosen and the gene is removed. APPRIS flag information can be found here: http://appris-tools.org/#/downloads or here: https://uswest.ensembl.org/info/genome/genebuild/transcript_quality_tags.html. Remapped from Ensembl GRCh38 to UCSC hg38

================================== ====================================
GGD Pacakge                        grch38-canonical-transcript-features-ensembl-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Ensembl
Data Version                       release-100_3-7-2020
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               grch38-canonical-transcript-features-ensembl-v1.gtf.gz, grch38-canonical-transcript-features-ensembl-v1.gtf.gz.tbi
Approximate Size of Each Data File grch38-canonical-transcript-features-ensembl-v1.gtf.gz: **11.49M**, grch38-canonical-transcript-features-ensembl-v1.gtf.gz.tbi: **256.64K**
Package Keywords                   Canonical, Canonical-Transcripts, Canonical-Isoforms, Gene-Features, GTF, Ensembl-Gene-Set, Annotated-Transcripts
Package Dependencies:              NA
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-canonical-transcript-features-ensembl-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-canonical-transcript-features-ensembl-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-canonical-transcript-features-ensembl-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-canonical-transcript-features-ensembl-v1