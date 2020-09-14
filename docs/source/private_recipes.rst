.. _private-recipes:

Private Recipes
===============

[:ref:`Click here to return to the home page <home-page>`]


Although GGD has been developed to provide reproducible data access and management for public scientific data, 
GGD can also be used to reproducibility curate and manage private data. 

For one reason or another, a researcher may wish to keep data private temporarily but still wish to use GGD to
document data access, curation, and management. Below are suggested steps that can be followed in order to use 
GGD to manage private data on a local machine. 

.. note:: 
    
    Private data management is not the primary use of GGD. GGD is used for public data access and use. It should be 
    noted that private data recipes **cannot** be added to the ggd-recipes repository on github, they **cannot** be 
    added to any ggd conda channel, and they **cannot** be added to ggd cloud caching services. All private data
    recipes will need to be stored and maintained by creator/user of those data recipes.


1. Create a private github repository to store private data recipes
-------------------------------------------------------------------

We suggest that you create a private github repository to store your private data recipes. This allows for data recipe 
versioning and storage. As noted above, private data recipes **cannot** be stored on the ggd repositories. 

It is important that these recipes are somehow stored and maintained as they are the infrastructure and manual that ggd will
use. They are key for the reproducibility and provenance aspects of data management. 


2. Create a ggd recipe 
----------------------

Use :code:`ggd make-recipe` to create the private data recipe(s) from a bash script with the instruction on data access, curations, 
and processing. 

see :ref:`ggd make-recipe <ggd-make-recipe>` for more information on how to create a data recipe 



3. Check and install the data recipe 
------------------------------------

Because the private ggd data recipe will not be added to the ggd library, you **won't** be able to use :code:`ggd install` to install the 
recipe. Instead you will use :code:`ggd check-recipe` command to install the recipe locally. In order to do this the :code:`-du` argument 
must be added to the :code:`ggd check-recipes` command. 

For example, if you have a private data recipe called *grch37-de-novo-callset-lark-v1* you would install it using the following command:

:code:`ggd check-recipe grch37-de-novo-callset-lark-v1 -du`

.. warning::
    
    The :code:`ggd check-recipe` command does not have a :code:`--prefix` argument. This means you have to be in the conda environment 
    where you wish to install the data. 


for more information on the :code:`ggd check-recipe` command see :ref:`ggd check-recipe <ggd-check-recipe>`

.. note::
    
    Installing private data recipes will take longer because the recipe goes through the normal check and validation step before it is 
    installed. Additionally, there is now way to cache private data recipes, so the speedup seen from installing public data recipes is 
    not available. 


4. Add the data recipe to github
---------------------------------

Now that the data recipe has been created, it has been checked, and installed, you can add it to your private github repository. 


.. note::
    
    We are suggesting adding the *data recipe* not the actual data to the private github repository 



5. How to access installed data from private recipe
----------------------------------------------------

Once a private data recipe has been installed on your system you can access and use it in a few different ways. 

A. Using environment variables

    A private GGD recipe will come with environment variables as does a non-private ggd recipes. You must be in the same environment where the 
    data recipe has been installed in order to use them. You must first run :code:`source activate base` before the environment variables are 
    active. 

B. Showing active environment variables

    Environment variables for private data recipes can be listed using :code:`ggd show-env`

    For more information about the :code:`ggd show-env` command see: :ref:`ggd-show-env`

C. Listing installed private recipes
    
    A list of installed data recipes, including private recipes, can be seen using :code:`ggd list`. 

    .. note::
        
        :code:`ggd list` has a :code:`--prefix` argument that is used to list installed data recipes in different 
        conda environments. The :code:`--prefix` argument  **can** be used for private recipes. This means you can list 
        private data recipes that are installed in a different conda environment then the currently active environment 
        you are using. 

    For more information about the :code:`ggd list` command see: :ref:`ggd-list`

D. Getting data files for private recipes

    As with normal data recipes, you can use the :code:`ggd get-files` command to get data files created by private data recipes. 

    .. note::

        :code:`ggd get-files` has a :code:`--prefix` argument that is used to get installed data files from different conda environments. 
        This :code:`--prefix` argument **can** be used for private recipes. This means you can get installed data files from private recipes
        that are in a different conda environment then the currently active one. 

    For more information about the :code:`ggd get-files` command see: :ref:`ggd-get-files`



6. GGD commands the won't work with private recipes
----------------------------------------------------

There are a few GGD commands that won't work with private recipes. Those include:

    * :code:`ggd search`
    * :code:`ggd predict-path`
    * :code:`ggd uninstall`
    * :code:`ggd pkg-info`



7. Uninstalling a previously installed private data recipe
-----------------------------------------------------------

To uninstall a private data recipe you will run :code:`ggd check-recipes <recipe name>` where *<recipe name>* represents the path to and name of the 
data recipe. 


.. note::

    The :code:`-du` argument is absent from the :code:`ggd check-recipe` command. 



Finally
-------

GGD is a data management system built to mange and distribute publicly available scientific data. As this is the main purpose of GGD we encourage 
user to add ggd recipes to the public ggd repositories for the scientific community to use. GGD is built to help remove the inconsistencies with 
data processing and management that has plagued researchers for year. Therefore, GGD will continue to encourage public data access, management, and 
reproducibility. We understand that sometimes data cannot be shared publicly, but that the convenience and power of GGD can assist researchers and 
scientist during an analysis. The features on this page are here to assist if you want to use GGD but truly need to retain data privacy. 
However, GGD will continue to promote public data sharing whenever possible, and therefore, the GGD features will be maintained to support such 
goals. 







