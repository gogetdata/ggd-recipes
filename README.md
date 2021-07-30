![GoGetData](https://github.com/gogetdata/gogetdata.github.io/blob/master/_images/GoGetData_name_logo.png)

Go Get Data: Access to and Use of Standardized and Reproducible Genomic Data
==============================================================================

[![CircleCI](https://circleci.com/gh/gogetdata/ggd-recipes/tree/master.svg?style=shield)](https://circleci.com/gh/gogetdata/ggd-recipes/tree/master)


Please cite the [Nature Communications GGD paper](https://www.nature.com/articles/s41467-021-22381-z) if you used GGD.


`ggd-recipes` are  conda recipes for genomic data. They provided a standardized and reproducible means for accessing, using, and managing 
genomic data. Built upon similar concepts of software management systems like Conda, ggd provides a simple way to find, access, use, and 
manage genomic data. ggd also eliminates the common problems a research has with finding, accessing, curating and processing genomic data. 
`ggd-recipes` are the fundamental elements within ggd that provide the infrastructure of data curation and management. 


<!--- Please see the design.md document in this directory l
--->

Much like `Conda` and `Bioconda`, ggd-recipes are commonly built by the community. We encourage community contributions and have 
a set of pages on the ggd documentation website with instructions to do so. See [GGD docs:contribute](https://gogetdata.github.io/contribute.html). Additionally, 
the command line interface (cli) [GGD docs:CLI](https://gogetdata.github.io/GGD-CLI.html) for ggd provides tools that simplify ggd recipe creation 
and testing. If you are familiar with creating a software recipe for Conda or Bioconda you will find GGD's approach much more simple and intuitive. 

Although the GGD team is working hard to add new recipes, our ability to add new recipes is limited. You are always welcome to 
request a recipe be added to ggd, but we encourage you to create one if you can. This will ensure that the recipe is created 
within a reasonable time frame, and that the recipe contains the information you are interested in.

To request a new data recipe please fill out the [GGD Recipe Request](https://forms.gle/3WEWgGGeh7ohAjcJA) Form.

## Documentation 
ggd documentation is provided on the [GGD docs](https://gogetdata.github.io/index.html) website. This is the best place to review and understand ggd, 
as well as to try to answer any questions you may have.   

Please see the [GGD docs: contribute](https://gogetdata.github.io/contribute.html) section to get detailed information on how to create a ggd data package, 
how to check the package, and how to add it to the ggd repo. This is the best place for information.


## QuickStart

> **_NOTE:_** You will need the ggd cli installed on your system. If you don't have it installed already see the [GGD docs:Using GGD](https://gogetdata.github.io/using-ggd.html) page. Once ggd is installed on your system you can use it to create a recipe.

#### Building a ggd data recipe. 
First you need to make a bash script. Here's an example that gets cpg-island for hg19.
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

A piece that may not be familiar is gsort (available via `conda install -c bioconda gsort`).
gsort will sort genomic files using a reference genome file. Genome files are available in the 
`genomes` folder above. 

`ggd` requires that the chromosomes be ordered as specified in the genome file and that files are bgzipped
and tabix where possible.


Here is an example of setting up your conda environment, installing ggd, and creating a recipe

```
$ conda config --add channels defaults
$ conda config --add channels ggd-genomics
$ conda config --add channels bioconda
$ conda config --add channels conda-forge

conda install -c bioconda ggd

ggd make-recipe --species Homo_sapiens \
                --genome-build hg19 \
                --authors <your name> \
                --package-version 1 \
                --data-version 27-Apr-2009 \
                --data-provider UCSC \
                --coordinate-base "0-based-inclusive" \
                --summary "cpg islands from UCSC" \
                --dependency htslib \
                --dependency gsort \
                --keyword CpG \
                --keyword region \
                --name cpg-islands \
                cpg.sh
```

This will write the recipe to `hg19-cpg-islands-ucsc-v1`

The `make-recipe` command is used to create a new recipe. We specify `gsort` as a dependency
along with `htslib` which provides tabix and bgzip (any software in bioconda or conda-forge can be used
as a dependency). If a ggd recipe is available through ggd it can also be used as a dependency. 

You will now need to test that the recipe was built correctly and make sure it install the correct data. to do this run: 

```
ggd check-recipe hg19-cpg-islands-ucsc-v1/
```

If this exits successfully, move the `hg19-cpg-islands-ucsc-v1` into the ggd-recipes repo,
push to your fork to github and then open a PR.

```
git checkout -b cpg-islands
mv hg19-cpg-islands-ucsc-v1 recipes/Homo_sapiens/hg19/
git add recipes/Homo_sapiens/hg19/hg19-cpg-islands-ucsc-v1
git push cpg-islands
# now go to github and open pull-request
```

Once the tests are done running (and passing), gogetdata members
can merge the pull-request. At that time, it will be added to the
`ggd-genomics` channel on anaconda.org.


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
* recipes should install to `$PREFIX/$species/$build/$recipe/`. This is facilitated by the [ggd command-line tool](https://github.com/gogetdata/ggd-cli) 
   which will create a conda recipe from a simple bash script and handle the directory location.
* scripts use `set -eo pipefail -o nounset`


## Contributing 

Visit the [ggd docs:contribute](https://gogetdata.github.io/contribute.html) page to get more information on how to contribute a ggd data package to the ggd repo. 

