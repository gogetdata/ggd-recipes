## ggd design

ggd is in *very* early stages, but we've made good progress in short time, including
several changes to `conda`, `conda-build`, and `anaconda-client` that facilitate use
on large datasets such as we see in genomics.

### Overview

GGD uses conda to manage recipes for getting genomic data. [Conda](http://conda.pydata.org/docs/)
nicely handles software dependencies. Data dependencies are very similar.

For example, to normalize a VCF using [vt](https://github.com/atks/vt) we have a
dependency on the `vt` software as well as the reference genome. These dependencies
can be specified clearly in `conda`.

### History

Originally ggd managed it's own installs. After realizing the problem of software and data dependencies
and the overlap with conda (and after seeing the success of the [bioconda project](https://bioconda.github.io/)
we have decided to use conda.

To bootstrap this, we have automated the conversion of the `ggd` recipies in [bcbio](https://github.com/chapmanb/cloudbiolinux/tree/master/ggd-recipes) to the conda format.

## Schema

Recipes will use the conda `pre-link.sh` script instead of the build. This means that the "binary" hosted on anaconda.org will
include the commands to create the data from it's original source. This is a convention, for resources that are less convenient to
acquire, we can have `built` packges.

The directory structure will be:

	`$PREFIX/$species/$build/$recipe/`

where $PREFIX is populated by `conda` species will be like `Homo_sapiens` or `Mus_musculus`
build will be `grch37` or `mm10` (must be lower-case) and recipe will be `$build-$name`, .e.g.
`hg19-clinvar`

The recipe must specify the $species and $build under extra/genome-build and extra/species respectively.
A fasta and genome-file must be present for those.

## Chromosome Naming

For each genome build, there will be a required .genome file in this repo that lists
that the chromosomes in their prescribed order and their lengths.

This genome file will dictate, for that build:
+ whether to use the 'chr' prefix or not
+ the chromosome ordering
+ the valid chromosomes.

We will provide `ggd` sub-command to strip or add prefixes and sort common file formats according to a genome file.

## Data Preprocessing and QC

Where possible all files should be bgzipped and tabixed. 
Records should be in the order dictated by the genome file described above.

All text-based files will be checked for sort-order as part of testing.

VCF files will go through a minimal validator. BED files will be checked for abberant spaces.

SAM files should be converted to sorted, indexed BAM.

#### VCF QC

Should there be a convention to [vt normalize](https://github.com/atks/vt) VCFs?

VCFs that have been `normalized` and `decomposed` should have a naming convention in the file
to indicate. e.g. .vt-norm-decomp.vcf.gz.

A single recipe may provide a lightly processed VCF and one that has also been normalized and decomposed?

### Fasta QC

all fastas should have a .fai (what about .dict)?

Should we enforce bwa and bowtie(2) indexing of of fasta?

## Subdirectories

a pre-link.sh script may (in practice) create any sub-directories. How can we
track this so we can still use `ggd recipe-files $recipe` ? glob.glob on the directory?

## Plans

We will provide a `ggd` executable that wraps soincludedme conda functionality and provides
additional functionality, e.g. to get the path of the clinvar recipe:

```
ggd recipe-dir hg19-clinvar
```
and the files:
```
ggd recipe-files hg19-clinvar
```

In addition, the wrapper to conda-build will have fixed species and builds. More can be added by pull
request, but this will mitigate the propagation of species and genome_builds due to spelling, e.g.
Homo_sapiens vs. homosapiens and genome_builds

```
ggd build --species Homo_sapiens --build hg19 /my/hg19-recipe.yaml
```

based on the `species` and `build` we will set env variables that will be available in the `pre-link.sh`.
The path of `$PREFIX/$species/$build/$recipe/` will be availabe as `$RECIPE_DIR` and should be used


## Testing

One of the reasons for the success of the bioconda project is the amazing automated testing. We will
need to figure out how to replicate this for data-based recipes.

This is started in the [ggd-utils repo](https://github.com/gogetdata/ggd-utils/)

Current testing:
+ Verifies that the genome file exists
+ Verifies that yaml file has `package` (with `version` number), `extra`, `genome-build`, `species`, `keywords`, and `about` sections
+ Verifies that species and build are valid
+ Verifies that files at least one file is installed by recipe being tested
+ Verifies that all files installed are tabixed, .tbi for those tabixed files, or .gzi, .fai, or .fasta (including .fasta, .fa, .fasta.gz, or .fa.gz) with corresponding .fai
+ Checks the sort order of the tabixed files using the genome file
+ Emits error if there are un-tabixed files that should be tabixed, fasta without index, or unknown formats not explicitly specified in `extra` section of meta.yaml


## Participation

Again, we'll follow the example of the bioconda and encourage contributions. For now, please open
issues with ideas or problems with what is outlined above.
