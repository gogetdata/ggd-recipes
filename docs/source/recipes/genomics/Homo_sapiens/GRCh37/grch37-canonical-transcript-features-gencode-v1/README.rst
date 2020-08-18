.. _`grch37-canonical-transcript-features-gencode-v1`:

grch37-canonical-transcript-features-gencode-v1
===============================================

|downloads|

Protein Coding Canonical Transcript Features for each protein coding gene id from GENCODE&#39;s v34 (Ensembl 100) comprehensive set of gene anntotations. Originally created on GRCh38 and mapped to GRCh37 by GENCODE (v34lift37). Some annotations were obtained from GENCODE v19 when mapping failed. Scaffoldings, assenbly patches, and alternative loci are NOT included. Canonical Transcripts are determined using the APPRIS annotation dataset. In short, for all protein coding transcripts, transcripts are filtered based on APPRIS isoform flags. If multiple transcripts of the same gene have equal flags, the isoform with the most exons is chosen. If all transcritps for a gene are not annotated by APPRIS, the transcript with the most exons is chosen as the canonical transcript. APPRIS flag information can be found here: http://appris-tools.org/#/downloads or here: https://uswest.ensembl.org/info/genome/genebuild/transcript_quality_tags.html. Features include: gene, transcript, exon, CDS, UTR, start_codon, stop_codon, and Selenocysteine.

================================== ====================================
GGD Pacakge                        grch37-canonical-transcript-features-gencode-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      GENCODE
Data Version                       release-34_03-24-2020
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               grch37-canonical-transcript-features-gencode-v1.gtf.gz, grch37-canonical-transcript-features-gencode-v1.gtf.gz.tbi
Approximate Size of Each Data File grch37-canonical-transcript-features-gencode-v1.gtf.gz: **15.54M**, grch37-canonical-transcript-features-gencode-v1.gtf.gz.tbi: **266.50K**
Package Keywords                   Canonical, Canonical-Transcripts, Canonical-Isoforms, Gene-Features, GTF, Gene-Features, Gene-Annotations, GTF, GENOCDOE-GTF, GENCODE-Gene-Sets, Annotated-Transcripts
Package Dependencies:              grch37-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-canonical-transcript-features-gencode-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-canonical-transcript-features-gencode-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-canonical-transcript-features-gencode-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-canonical-transcript-features-gencode-v1