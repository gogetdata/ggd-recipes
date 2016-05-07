Go Get Data: "Making data great again"
======================================

[![Build Status](https://travis-ci.org/gogetdata/ggd-recipes.svg?branch=dev)](https://travis-ci.org/gogetdata/ggd-recipes)


`ggd-recipes` houses conda recipes for genomic data. The automated tests ensure data quality and fidelity to
the specified genome and build. See below for specific checks that are implemented.


Please see the design.md document in this directory

For any comments / issues or to be added to the project, open an issue or email bpederse@gmail.com

You can use the recipes from this repo using the [ggd-alpha channel](https://anaconda.org/ggd-alpha/) from anaconda.org, e.g:

```
conda install -c ggd-alpha hg19-dbsnp
```

**NOTE**: many recipes will depend on software in [bioconda](https://github.com/bioconda/bioconda-recipes) so please use: 

```
conda config --add channels bioconda
```

## QuickStart

to build a recipe. First make a bash script. Here's an example that gets cpg-island for hg19.
We will place it in a file called `cpg.sh`

```
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome
wget -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/cpgIslandExt.txt.gz \
    | gzip -dc \
    | cut -f 2-5 \
	| gsort /dev/stdin $genome \
    | bgzip -c > cpg.bed.gz

tabix cpg.bed.gz

```

A piece that may not be familiar is gsort (available via `conda install -c bioconda gsort`)
that will sort according the a genome file.

`ggd` requires that the chromosomes be ordered as specified in the genome file and that files are bgzipped
and tabix where possible.

Now, we use the ggd command-line tool to turn this into a proper recipe:

```
conda config --add channels bioconda

pip install -U git+git://github.com/gogetdata/ggd-cli.git
conda install -y conda-build

ggd from-bash --species Homo_sapiens --genome-build hg19 \
              --authors bsp --version 1 \
              --dependency htslib --dependency gsort \
              --summary "cpg islands from UCSC" \
              --keyword CpG --keyword region \
              cpg-islands \
              cpg.sh
```

This will write the recipe to `hg19-cpg-islands`

Those are all the options for the `from-bash` command we specify `gsort` as a dependency
along with `htslib` which provides tabix and bgzip (any software in bioconda can be used
as a dependency). We can also depend on other ggd recipes.
The species and genome-build arguments must be available in the master branch of `ggd`.

After this, we have a recipe. To run the same data quality tests (see below) as `travis-ci`
when you make a PR, run:

```
ggd check-recipe hg19-cpg-islands/
```

This should exit successfully and then move this into its place in the ggd-recipes repo,
push to your fork on github and then open a PR.

```
git checkout -b cpg-islands
mv hg19-cpg-islands recipes/Homo_sapiens/hg19/
git add recipes/Homo_sapiens/hg19/hg19-cpg-islands
git push brentp cpg-islands
# now go to github and open pull-request
```

Once the tests are done running (and passing), gogetdata members
can merge the pull-request. At that time, it will be added to the
`ggd-alpha` channel on anaconda.org.


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
