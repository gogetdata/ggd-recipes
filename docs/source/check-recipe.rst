.. _ggd-check-recipe:

ggd check-recipe
================

[:ref:`Click here to return to the home page <home-page>`]

ggd check-recipe is used to check a ggd recipe built by running :ref:`ggd make-recipe <ggd-make-recipe>`. :code:`ggd make-recipe`
takes a bash script used to download and process data and turns it into a ggd data recipe. :code:`ggd check-recipe` should
then be called to test that newly built ggd recipe.

:code:`ggd check-recipe` is a part of the tool set used to create and contribute data packages to the ggd data repository.
For more information about using the ggd workflow to contribute to ggd see :ref:`contribute <make-data-packages>`.


Using ggd check-recipe
----------------------
Checking a newly built ggd recipe is easy using the :code:`ggd check-recipe` tool.
Running :code:`ggd check-recipe -h` will give you the following help message:

check-recipe arguments: 

-h, --help      show this help message and exit

/recipe_path    (Positional) Path to recipe directory (can also be path to the .bz2)
                ('/' indicates a placeholder and is not part of the argument name)

Additional argument explanation: 
++++++++++++++++++++++++++++++++

The only required argument is the :code:`recipe_path` and refers to the directory you would like ``ggd check-recipe``
to check. When using :ref:`ggd make-recipe <ggd-make-recipe>` to create a ggd recipe, make-recipe will
create a new directory with three new files. The recipe_path should be the path to the new directory created
from using `ggd make-recipe`.

Running :code:`ggd check-recipe <recipe-path>` will build, install, and check the recipe to ensure the recipe works correctly.

Example
-------

1. An example of creating a ggd recipe from ``ggd make-recipe`` and using ``ggd check-recipe`` to check the recipe
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    * get_data.sh (A bash script used to create a recipe with :code:`ggd make-recipe`)

    ::

        #!/bin/sh
        set -eo pipefail -o nounset
        wget --quiet --no-check-certificate \
            http://hgdownload.cse.ucsc.edu/goldenpath/hg19/phastCons100way/hg19.100way.phastCons.bw

    * Using :code:`ggd make-recipe` to create a ggd recipe::

        $ ggd make-recipe -s Homo_sapiens -g hg19 \
            --author mjc --ggd_version 1 \
            --data_version 09-Feb-2014 \
            --summary 'phastCons scores for MSA of 99 genomes to hg19' \
            -e hg19.100way.phastCons.bw -k phastCons \
            -k conservation get_data.sh

    * A new directory called **hg19-phastcons** is now present in the current working directory
        * The **hg19-phastcons** directory contains three files: **meta.yaml**, **post-link.sh**, and **recipe.sh**
        * Lets say the path to **hg19-phastcons** is ``/user/home/hg19-phastcons/``

    * Using :code:`ggd check-recipe` we will build, install, and test the new **hg19-phastcons** recipe::

        $ ggd check-recipe /user/home/hg19-phastcons/

          No numpy version specified in conda_build_config.yaml.  Falling back to default numpy value of 1.11
          WARNING:conda_build.metadata:No numpy version specified in conda_build_config.yaml.  Falling back to default numpy value of 1.11
          INFO:conda_build.variants:Adding in variants from internal_defaults
          INFO:conda_build.metadata:Attempting to finalize metadata for hg19-phastcons
          INFO:conda_build.build:Packaging hg19-phastcons
          INFO:conda_build.build:Packaging hg19-phastcons-1-0
          No files or script found for output hg19-phastcons
          WARNING:conda_build.build:No files or script found for output hg19-phastcons
          /TMP/hg19-phastcons-1-0.tar.bz2: C1115 Found invalid license "None" in info/index.json
          /TMP/hg19-phastcons-1-0.tar.bz2: C1134 Found pre/post link file "bin/.hg19-phastcons-post-link.sh" in archive
          INFO:conda_build.variants:Adding in variants from /TMP/info/recipe/conda_build_config.yaml
          Solving environment: done

          ## Package Plan ##

           environment location: /scratch/ucgd/lustre/work/u1138933/anaconda2

             added / updated specs:
                 - hg19-phastcons


          The following packages will be downloaded:

          package                    |            build
          ---------------------------|-----------------
          hg19-phastcons-1           |                0           5 KB  local

          The following NEW packages will be INSTALLED:

            hg19-phastcons: 1-0 local


          Downloading and Extracting Packages
          hg19-phastcons-1     | 5 KB      | ############################ | 100%
          Preparing transaction: done
          Verifying transaction: done
          Executing transaction: done
          modified files:
          :: /<conda root>/share/ggd/Homo_sapiens/hg19/hg19-phastcons/1/hg19.100way.phastCons.bw

          checking /scratch/ucgd/lustre/work/u1138933/anaconda2/share/ggd/Homo_sapiens/hg19/hg19-phastcons/1/hg19.100way.phastCons.bw

            ****************************
            * Successful recipe check! *
            ****************************

    * If the recipe fails, a message will be displayed stating that it failed and (hopefully) why it failed.
