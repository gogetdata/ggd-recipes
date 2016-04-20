Go Get Data: "Making data great again"
======================================

[![Build Status](https://travis-ci.org/gogetdata/ggd-recipes.svg?branch=dev)](https://travis-ci.org/gogetdata/ggd-recipes)


`ggd-recipes` houses conda recipes for genomic data. The automated tests ensure data quality and fidelity to
the specified genome and build. See below for specific checks that are implemented.


Please see the design.md document in this directory

For any comments / issues or to be added to the project, open an issue or email bpederse@gmail.com

You can use the recipes from this repo using the [ggd-alpha channel](https://anaconda.org/ggd-alpha/) from anaconda.org, e.g:

```
conda install -c https://conda.anaconda.org/ggd-alpha hg19-dbsnp
```

## Recipe Requirements

* recipes must be only for organism/genome-builds in the `genomes` folder. (open a new issue or PR to add a new organism).
* tab-delimited genome feature files must be sorted according the the genome feature file
* `.fa` and `.fasta` must have an associated `.fai`
* `.bed`,`.gff`, `.gtf`, `.vcf` must be bgzipped and tabixed (with sort order matching genome file).
* non tab-delimited files must be included in the `extra/extra-files` section in the meta.yaml
* recipe must have an `about/summary` section in the yaml.
* there must be `genome-build`, `species`, and `keywords` sections in the `meta.yaml`


## Conventions

* Use `--quiet` argument to `wget` or log will be filled with progress
* each PR should add or change as few recipes as possible.
* recipes should install to `$PREFIX/$species/$build/$recipe/`. This is facilitated by the [ggd command-line tool](https://github.com/gogetdata/ggd-cli) which will create a conda recipe from a simple bash script and handle the directory location.
* scripts use `set -eo pipefail -o nounset`
