.. _contrib-recipe:

Contributing a ggd recipe
=========================

The following steps outline how to create, check, and add a ggd data recipe.

1. Update local forked repo
---------------------------
You will need to update the forked ggd-recipes repo on your local machine before
you add a recipe to it.

* Navigate to the forked ggd-recipes repo on your local machine
* Once in the directory run the following commands::

    $ git checkout master
    $ git pull upstream master
    $ git push origin master


2. Writing a bash script to get data
------------------------------------
Here you will need create a bash script that extract and process the data you would
like to add to ggd.

The following will outline steps used to create the hg19-gaps ggd data recipe:

* First locate the data you would like to extract.
    * Example: hg19-gaps from the USCS genome browser track:

    ::

        http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/gap.txt.gz

* Next, identify if you need a genome coordinates file. Many of these are hosted on the ggd-recipes repo.
  If the coordinates file is not available you can either add one to the ggd-recipes repo or ask a member of the
  ggd team to add one.

* Example: hg19 genome build coordinates file::

    https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

* Next, identify what format you want the final files to be in and what processing needs to be done
    * Example:
        1. need to decompress a gzipped file
        2. need to extract the chrom, start, end, size, type, and strand columns
        3. needs to sort the resulting extraction
        4. need to bgzip the new sorted extraction
        5. need to tabix the bgzip sorted file

* Next, create bash script that contains the steps in order to extract and process the data file:
    * Example (bash script)::

        genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
        wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/gap.txt.gz \
            | gzip -dc \
            | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tsize\ttype\tstrand"} {print $2,$3,$4,$7,$8,"+"}' \
            | gsort /dev/stdin $genome \
            | bgzip -c > gaps.bed.gz

        tabix gaps.bed.g

You should run the script to make sure it works and that the processed files are what you expect them to be.

3. Create a ggd recipe using the ggd cli
----------------------------------------
The ggd command line interface (cli) contains tools to create and test a data recipe.

If it has not been installed, install the ggd cli following the steps outline in :ref:`Using GGD <using-ggd>`.

With the ggd cli installed you can now transform your bash script into a ggd recipe.

Example:
++++++++

    Assuming your bash script created in step 2 is called *hg19_data_recipe.sh*, run the following command to turn
    it into a ggd recipe::

        $ ggd from-bash -s Homo_sapiens -g hg19 --author mjc \
            --ggd_version 1 --data_version 27-Apr-2009 \
            --summary 'Assembly gaps from USCS' \
            -k gaps -k region gaps hg19_data_recipe.sh

    The :code:`ggd from-bash` tool transforms the bash script you created into a data recipe. Running the above code will create
    a data recipe called *hg19-gaps*, which will be a directory and will contain three files. For more information on the
    :code:`ggd from-bash` command see :ref:`from-bash <ggd-from-bash>`.

4. Build, install, and check the data recipe
--------------------------------------------
Now that you have created a ggd data recipe you need to test it to make sure it not only extracts and processes the data, but
that the recipe was correctly created and provides the necessary instruction for data package creation.

To do this use the :code:`ggd check-recipe` command.

Example:
++++++++

    Using the hg19-gaps recipe created in step 3, run the following command::

        $ ggd check-recipe hg19-gaps

    Or if you are in a different directory on your machine run::

        $ ggd check-recipe <Path_To_hg19-gaps>

    This command will build, install, and check the validity of the new ggd data recipe.
    For more information about :code:`ggd check-recipe` see :ref:`check-recipe <ggd-check-recipe>`

5. Submit the new ggd recipe to the original ggd-recipes repo
-------------------------------------------------------------
Once the ggd recipe you created passes step 4 you are ready to add it to the original ggd-recipes repo.

To do this you will need to create a **pull request**.

From your local machine, add the new data recipe you created to the forked ggd-recipes repo. You will add it
to the ``recipes/`` directory. If you do not put it in the right directory it will be rejected.
The recipes file convention is as follows:

    * All recipes are stored within the **ggd-recipes/recipes** directory
    * The recipes directory has the following format::

        /<path to forked ggd-recipes repo>/recipes/<ggd channel>/<species>/<genome-build>/

      * :code:`<path to forked ggd-recipes repo>` is the path to the forked ggd-recipes repo on your local machine.
      * :code:`recipes` is the **recipes** directory.
      * :code:`<ggd channel>` is the ggd channel that recipe should go in. This depends on the type of data you are adding.
        For the hg19-gaps example the channel would be **genomics**.
      * :code:`<species>` is the species corresponding to these data. For the hg19-gaps example this would be **Homo_sapiens**.
      * :code:`<genome-build>` is the genome build for the data. For the hg19-gaps example this would be **hg19**.

For the hg19-gaps recipe above you would use the following commands::

    $ mv hg19-gaps /<forked ggd-recipes>/recipes/genomics/Homo_sapiens/hg19/

Once the recipe is there you will need to add the recipe to your forked ggd-recipe repo.
Navigate to the forked ggd-recipe directory and use the following commands:

    * Add the recipe to the git repo::

        $ git add /recipes/genomics/Homo_sapiens/hg19/hg19-gaps/

    * Commit the addition to the repo (A text editor will open up. Add a comment about the new recipe and save it)::

        $ git commit

    * Push the commit to your fork repo on github (You will be asked to fill out your github credentials)::

        $ git push origin

    * Go to the ggd-recipes github page for your username (https://github.com/<USERNAME>/ggd-recipes/).

    * Under the green "Clone or download" button click on **Pull request**.

    * Where it says **base fork:** make sure it is on **gogetdata/ggd-recipes**. And where it says **base:** make sure it
      is on **master**.

    * Click the green **Create pull request** button.

    * Add some comments and complete the pull request.

You have now created a pull request with your new data recipe. The recipe will go through a continuous integration
step where the recipe will be tested.

If it passes, the recipe will be added to the gogetdata/ggd-recipes repo and anyone using the ggd tool will be
able to access it.

If it does not pass, you will be informed by the ggd team, and they will work with you on getting it working.
