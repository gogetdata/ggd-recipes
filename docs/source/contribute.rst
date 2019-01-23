.. _make-data-packages:

Contribute
==========

Similar to **Conda** and **Biconda**, ggd encourages and relies on community contributions. Our vision is that 
ggd becomes a widely used data managment system in genomics and other research fields. ggd will help reduce 
the time it takes to find, extract, and process the necessary data for any analysis, and support research 
reproducibility. Similar to the use of conda for package managment, and Bioconda for biological software
pacakge managment, ggd will become a common tool for accessing the required data for your reserach needs.

With the contributions and maintenance of data recipes from the research community, ggd will become a common
tool for using scientific data. ggd will empower scientist to perform and analyze research quicker and 
more accurately, providing a steady tool for scholarly advancement. 

We invite everyone to contribute data recipes to ggd, and thus providing access to scientific data for 
scientists around the world. 

The ggd tool has been developed to help with contributing data recipes to ggd, and a few functions are 
provided to make this process easy. Outlined below is the steps that should be followed to create data 
recipe and add it to the ggd data repository. 

1. :ref:`Github <setup-github>` 

    * You will need a github account and a forked repository of ggd-recipes. 
    * Once you have a github account and you have a forked ggd-recipes repo, you do not need to do step 1 again.

2. :ref:`Make a ggd recipe <contrib-recipe>`

    * The following steps will outline how to create a ggd data recipe, how to test it, and how to add it to the 
      gogetdata/ggd-recipes repo

3. Continous Integration testing with Circle CI

    * We use Circle CI to test all new recipes. Any recipe that passes will be officially added to the ggd repo
      and will be available to anyone using the ggd install tool. If it does not pass, the ggd team will work 
      with you on getting it to pass. 
        

Contents: 

.. toctree::
    :maxdepth: 2

    github-setup
    contribute-recipe

