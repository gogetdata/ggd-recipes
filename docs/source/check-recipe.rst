.. _ggd-check-recipe:

ggd check-recipe
================

[:ref:`Click here to return to the home page <home-page>`]

`check-recipe` is used to validate a recipe created from running :code:`ggd make-recipe`
----------------------------------------------------------------------------------------

:code:`ggd check-recipe` is used to check a ggd recipe built by running :ref:`ggd make-recipe <ggd-make-recipe>`. :code:`ggd make-recipe`
takes a bash script used to download and process data and turns it into a ggd data recipe. :code:`ggd check-recipe` should
then be called to test the newly built ggd recipe.

:code:`ggd check-recipe` is a part of the tool set used to create and contribute data packages to the ggd data repository.
For more information about using the ggd workflow to contribute to ggd see :ref:`contribute <make-data-packages>`.


Using ggd check-recipe
----------------------
Checking a newly built ggd recipe is easy using the :code:`ggd check-recipe` tool.
Running :code:`ggd check-recipe -h` will give you the following help message:

check-recipe arguments: 

+-----------------------+----------------------------------------------------------------------------------+
| ggd check-recipe      | Convert a ggd recipe created from `ggd make-recipe` into a data package. Test    |
|                       | both ggd data recipe and data package                                            |
+=======================+==================================================================================+
| -h, --help            |   show this help message and exit                                                |
+-----------------------+----------------------------------------------------------------------------------+
| -d, --debug           |  (Optional) Set the stdout log level to debug                                    | 
+-----------------------+----------------------------------------------------------------------------------+
| -du, --dont_uninstall |   (Optional) By default the newly installed local ggd                            |
|                       |   data package is uninstalled after the check has                                |
|                       |   finished. To bypass this uninstall step (to keep the                           | 
|                       |   local package installed) set this flag "--                                     |
|                       |   dont_uninstall"                                                                |
+-----------------------+----------------------------------------------------------------------------------+
| recipe_path           |   **Required** Path to recipe directory (can also be path to the .bz2)           |
+-----------------------+----------------------------------------------------------------------------------+


Additional argument explanation: 
++++++++++++++++++++++++++++++++


Required arguments: 

* *recipe_path:* The :code:`recipe_path` is a positional argument and represents the path the the directory/recipe created from 
  running :code:`ggd make-recipe`. This path is required, as it represents the recipe that will be tested and validated. 

Optional arguments:

* *-d:* The :code:`-d` flag is used to provide additional output from running "check-recipe". This is useful if the tests 
  fail and it is unclear why they have failed. The output can be overwhelming, so if it is not needed try not to set this 
  flag. 

* *-du:* The :code:`-du` flag is used to tell `check-recipe` not to uninstall the data after it has finished testing the 
  recipe. In order to test a portion of the recipe, the recipe will be packaged into a data package and will be installed. 
  The default functionality for `check-recipe` is to uninstall that file once the tests have finished. If you would like 
  to keep the local data package installed add :code:`-du` to your `check-recipe` command.


The only required argument is the :code:`recipe_path` and refers to the directory you would like ``ggd check-recipe``
to check. When using :ref:`ggd make-recipe <ggd-make-recipe>` to create a ggd recipe, make-recipe will
create a new directory with four new files. The recipe_path should be the path to the new directory created
from using `ggd make-recipe`.

Running :code:`ggd check-recipe <recipe-path>` will build, install, and test and validate the recipe to ensure the recipe works correctly.

Example
-------

1. An example of creating a ggd recipe from ``ggd make-recipe`` and using ``ggd check-recipe`` to check the recipe
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    * get_data.sh (A bash script used to create a recipe with :code:`ggd make-recipe`)

    ::

        #!/bin/sh
        set -eo pipefail -o nounset
        wget --quiet --no-check-certificate \
            -O hg19-phastcons-ucsc-v1.bw \
            http://hgdownload.cse.ucsc.edu/goldenpath/hg19/phastCons100way/hg19.100way.phastCons.bw

    * Using :code:`ggd make-recipe` to create a ggd recipe

    ::

      $ ggd make-recipe \
          -s Homo_sapiens \
          -g hg19 \
          --author mjc \
          -pv 1 \
          -dv 09-Feb-2014 \
          -dp UCSC\
          --summary 'phastCons scores for MSA of 99 genomes to hg19' \
          -cb 0-based-inclusive \
          -k phastCons \
          -k conservation \
          -n phastcons \
          get_data.sh

    * A new directory called **hg19-phastcons-ucsc-v1** is now present in the current working directory
        * The **hg19-phastcons-ucsc-v1** directory contains four files: **meta.yaml**, **post-link.sh**, **recipe.sh**, and **checksums_file.txt**
        * Lets say the path to **hg19-phastcons-ucsc-v1** is ``/user/home/hg19-phastcons-ucsc-v1/``

    * Using :code:`ggd check-recipe` we will build, install, and test the new **hg19-phastcons-ucsc-v1** recipe

    ::

        $ ggd check-recipe /user/home/hg19-phastcons-ucsc-v1/

          No numpy version specified in conda_build_config.yaml.  Falling back to default numpy value of 1.11
          WARNING:conda_build.metadata:No numpy version specified in conda_build_config.yaml.  Falling back to default numpy value of 1.11
          INFO:conda_build.variants:Adding in variants from internal_defaults
          INFO:conda_build.metadata:Attempting to finalize metadata for hg19-phastcons-ucsc-v1
          INFO:conda_build.build:Packaging hg19-phastcons-ucsc-v1
          INFO conda_build.build:build(1540): Packaging hg19-phastcons-ucsc-v1
          INFO:conda_build.build:Packaging hg19-phastcons-ucsc-v1-1-0
          INFO conda_build.build:bundle_conda(879): Packaging hg19-phastcons-ucsc-v1-1-0
          No files or script found for output hg19-phastcons-ucsc-v1
          WARNING:conda_build.build:No files or script found for output hg19-phastcons-ucsc-v1
          WARNING conda_build.build:bundle_conda(959): No files or script found for output hg19-phastcons-ucsc-v1
          Importing conda-verify failed.  Please be sure to test your packages.  conda install conda-verify to make this message go away.
          WARNING:conda_build.build:Importing conda-verify failed.  Please be sure to test your packages.  conda install conda-verify to make this message go away.
          WARNING conda_build.build:bundle_conda(1030): Importing conda-verify failed.  Please be sure to test your packages.  conda install conda-verify to make this message go away.
          INFO:conda_build.variants:Adding in variants from /scratch/local/u1138933/tmpn3m0b150/info/recipe/conda_build_config.yaml
          INFO conda_build.variants:_combine_spec_dictionaries(189): Adding in variants from /scratch/local/u1138933/tmpn3m0b150/info/recipe/conda_build_config.yaml
          Collecting package metadata (current_repodata.json): ...working... Unable to retrieve repodata (response: 404) for https://conda.anaconda.org/ggd-genomics/linux-64/current_repodata.json

          done
          Solving environment: ...working... Could not run SAT solver through interface 'pycryptosat'.

          done
          initializing UnlinkLinkTransaction with
            target_prefix: <conda root>
            unlink_precs:
              
            link_precs:
              local::hg19-phastcons-ucsc-v1-1-0



          ## Package Plan ##

            environment location: <conda root>

            added / updated specs:
              - conda=4.7.12
              - hg19-phastcons-ucsc-v1


          The following packages will be downloaded:

              package                    |            build
              ---------------------------|-----------------
              hg19-phastcons-ucsc-v1-1   |                0           5 KB  local
              ------------------------------------------------------------
                                                     Total:           5 KB

          The following NEW packages will be INSTALLED:

            hg19-phastcons-uc~ <conda root>/conda-bld/noarch::hg19-phastcons-ucsc-v1-1-0


          Preparing transaction: ...working... done
          Verifying transaction: ...working... done
          Executing transaction: ...working... ===> LINKING PACKAGE: local::hg19-phastcons-ucsc-v1-1-0 <===
            prefix=<conda root>
            source=<conda root>/pkgs/hg19-phastcons-ucsc-v1-1-0


          done
          :ggd:check-recipe: modified files:
             :: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-phastcons-ucsc-v1/1/hg19-phastcons-ucsc-v1.bw


          :ggd:check-recipe: > checking <conda root>/share/ggd/Homo_sapiens/hg19/hg19-phastcons-ucsc-v1/1/hg19-phastcons-ucsc-v1.bw

          :ggd:check-recipe: Updating the list of final data files

          :ggd:check-recipe: Updating md5sums for final data files


            ****************************
            * Successful recipe check! *
            ****************************


            **********************************
            * Recipe ready for Pull Requests *
            **********************************



          :ggd:check-recipe: The --dont_uninstall flag was not set 

           Uninstalling the locally built ggd data package

          :ggd:uninstall: Removing hg19-phastcons-ucsc-v1 version 1 file(s) from ggd recipe storage

          :ggd:uninstall: Deleteing 10 items of hg19-phastcons-ucsc-v1 version 1 from your conda root

          :ggd:env: Removing the ggd_hg19_phastcons_ucsc_v1_dir environment variable

          :ggd:env: Removing the ggd_hg19_phastcons_ucsc_v1_file environment variable


    * If the recipe fails, a message will be displayed stating that it failed and (hopefully) why it failed.
