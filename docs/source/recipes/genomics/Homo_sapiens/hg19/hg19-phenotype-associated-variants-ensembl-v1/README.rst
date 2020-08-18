.. _`hg19-phenotype-associated-variants-ensembl-v1`:

hg19-phenotype-associated-variants-ensembl-v1
=============================================

|downloads|

**Liftover** All variants at the time of Ensembl release 99 that have a known phenotype association. Decomposed and Normalized. Liftover from GRCh38 to GRCh37. Remapped from Ensembl GRCh37 to UCSC hg19. Ensembl variant info page can be found at: https://uswest.ensembl.org/info/genome/variation/index.html

================================== ====================================
GGD Pacakge                        hg19-phenotype-associated-variants-ensembl-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Ensembl
Data Version                       release-99_11-7-19
Genomic File Type                  vcf
Data file coordinate basing        1-based-inclusive
Package's Data Files               hg19-phenotype-associated-variants-ensembl-v1.vcf.gz, hg19-phenotype-associated-variants-ensembl-v1.vcf.gz.tbi
Approximate Size of Each Data File hg19-phenotype-associated-variants-ensembl-v1.vcf.gz: **10.60M**, hg19-phenotype-associated-variants-ensembl-v1.vcf.gz.tbi: **195.52K**
Package Keywords                   genetic-varaition, pheontype-associated, Known-Phenotype, Phenotype-Associated-Variants, VCF, varaint-info, Ensembl-variantion
Package Dependencies:              bcftools, crossmap, grch37-reference-genome-ensembl-v1, grch38-reference-genome-ensembl-v1, gsort, hg19-chrom-mapping-ensembl2ucsc-ncbi-v1, hg19-reference-genome-ucsc-v1, htslib, vt, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-phenotype-associated-variants-ensembl-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-phenotype-associated-variants-ensembl-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-phenotype-associated-variants-ensembl-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-phenotype-associated-variants-ensembl-v1