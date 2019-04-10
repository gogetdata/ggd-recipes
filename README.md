Go Get Data: "Easily Managing Your Genomic Data"
================================================

[![CircleCI](https://circleci.com/gh/gogetdata/ggd-recipes/tree/master.svg?style=shield)](https://circleci.com/gh/gogetdata/ggd-recipes/tree/master)


`ggd-recipes` houses conda recipes for genomic data. The automated tests ensure data quality and fidelity to
the specified genome and build. See below for specific checks that are implemented.


<!--- Please see the design.md document in this directory l
--->

For any comments / issues or to be added to the project, open an issue or email bpederse@gmail.com

You can use the recipes from this repo using the [ggd-genomics channel](https://anaconda.org/ggd-genomics/) from anaconda.org, e.g:

```
conda install -c ggd-genomics hg19-dbsnp
```

**NOTE**: many recipes will depend on software in [bioconda](https://github.com/bioconda/bioconda-recipes) so please use: 

```
conda config --add channels bioconda
```

## Documentation 
ggd documentation is provide on the [ggd docs](https://gogetdata.github.io/index.html) website. This is the best place to review and understand ggd, as well as to try to answer any questions you may have.  

Please see the [ggd docs: contribute](https://gogetdata.github.io/contribute.html) section to get detailed information on how to create a ggd data package, how to check the package, and how to add it to the ggd repo. This is the best place for information.


## QuickStart

Building a ggd data recipe. First you need to make a bash script. Here's an example that gets cpg-island for hg19.
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
$ conda config --add channels defaults
$ conda config --add channels ggd-genomics
$ conda config --add channels bioconda
$ conda config --add channels conda-forge

$ conda install -y --file https://raw.githubusercontent.com/gogetdata/ggd-cli/master/requirements.txt
$ pip install -U git+git://github.com/gogetdata/ggd-cli

ggd make-bash --species Homo_sapiens --genome-build hg19 \
              --authors bsp --ggd_version 1 \
              --data_version 27-Apr-2009 \
              --dependency htslib --dependency gsort \
              --summary "cpg islands from UCSC" \
              --keyword CpG --keyword region \
              cpg-islands \
              cpg.sh
```

This will write the recipe to `hg19-cpg-islands`

Those are all the options for the `make-bash` command we specify `gsort` as a dependency
along with `htslib` which provides tabix and bgzip (any software in bioconda can be used
as a dependency). We can also depend on other ggd recipes.
The species and genome-build arguments must be available in the master branch of `ggd`.

You will no need to test that the recipe was built correctly and make sure it install the correct data. to do this run: 

```
ggd check-recipe hg19-cpg-islands/
```

If this exits successfully, move this into its place in the ggd-recipes repo,
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


## Contributing 

Vist the [ggd docs:contribute](https://gogetdata.github.io/contribute.html) page to get more information on how to contribute a ggd data package to the ggd repo. 

