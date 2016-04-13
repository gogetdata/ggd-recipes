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

## Plans

We will provide a `ggd` executable that wraps some conda functionality and provides
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

## Participation

Again, we'll follow the example of the bioconda and encourage contributions. For now, please open
issues with ideas or problems with what is outlined above.
