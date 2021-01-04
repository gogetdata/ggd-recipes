.. _ggd-predict-path:

ggd predict-path
================

[:ref:`Click here to return to the home page <home-page>`]


:code:`ggd predict-path` is used to predict that path of a data file from a ggd data package that has not been installed yet. Workflows, such as Snakemake, 
require knowledge of the file path prior to running the workflow. Using the `predict-path` tool would allow someone using Snakemake to provide the predict file 
paths of the data files they would like to use without having to pre-install the data packages.The installation of the data packages could take place later in the 
workflow process. 


Using ggd predict-path
----------------------
Use :code:`ggd predict-path` to predict the path of a data file prior to installing the ggd data package.
Running :code:`ggd predict-path -h` will give you the following message:


predict-path arguments:

+-------------------------------+---------------------------------------------------------------------------------------+
| ggd predict-path              | Get a predicted install file path for a data package before it is installed.          |
|                               | (Use for workflows, such as Snakemake)                                                |
+===============================+=======================================================================================+
| ``-h``, ``--help``            | show this help message and exit                                                       | 
+-------------------------------+---------------------------------------------------------------------------------------+
| ``-c``, ``--channel``         | The ggd channel of the recipe to fine. (Deafult = genomics)                           |
+-------------------------------+---------------------------------------------------------------------------------------+
| ``--prefix``                  | (Optional) The name or the full directory path to an                                  |
|                               | conda environment. The predicted path will be based on                                |
|                               | this conda environment. When installing, the data                                     |
|                               | package should also be installed in this environment.                                 |
|                               | (Only needed if not predicting for a path in the                                      |
|                               | current conda environment)                                                            |
+-------------------------------+---------------------------------------------------------------------------------------+
| ``--id``, ``meta-recipe ID``  | (Optional) The ID to predict the path for if the package is a meta-recipe. If it is   |
|                               | not a meta-recipe it will be ignored                                                  |
+-------------------------------+---------------------------------------------------------------------------------------+
| ``-pn``, ``--package-name``   | **Required** The name of the data package to predict a                                |
|                               | file path for                                                                         |
+-------------------------------+---------------------------------------------------------------------------------------+
| ``-fn``, ``--file-name``      | **Required if --dir-path not used** The name of the file to predict that path         |
|                               | for. It is best if you give the full and correct name                                 |
|                               | of the file to predict the path for. If not, ggd will                                 |
|                               | try to identify the right file, but won't guarantee                                   |
|                               | that it is the right file                                                             |
+-------------------------------+---------------------------------------------------------------------------------------+
| ``-dir-path``                 | **Required if --file-name not used** Whether or not to get the predicted directory    | 
|                               | path rather then the predicted file path. If both --file-name and --dir-path are      |
|                               | provided the --file-name will be used and --dir-path will be ignored                  |
+-------------------------------+---------------------------------------------------------------------------------------+



Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments:

* *-pn:* The :code:`-pn` flag represents the data package name for which to predict a file path for. (NOTE: the file 
  path is for a data file from this data package and not the data package itself)


One Argument Required:

* *-fn:* The :code:`-fn` flag represents the name of the data file for which to predict the file path for. (NOTE: this is 
  the actual file from the data package to predict the path for) You can use :code:`ggd search` or check the 
  :ref:`Available packages <recipes>` page to get the name of the files provided by the package

* *--dir-path* The :code:`--dir-path` flag is used to the the predicted directory path of the installed files rather then the
  exact file path. This is specifically useful for meta-recipes, where the file-path cannot be predicted because of the 
  dynamic nature of meta-recipes. 

.. note::

    Either the :code:`--file-name` or the :code:`--dir-path` parameter is required. If both are provided then the :code:`--file-path`
    will be used and the :code:`--dir-path` ignored. If neither one is given then the :code:`predict-path` command will exit and 
    prompt for one.


Optional arguments:

* *-c:* The :code:`-c` flag represents the ggd channel. The default channel is *genomics*.
   
* *--prefix:* The :code:`--prefix` flag is used to get to the install path for a data file in a specific conda  environment/prefix
  that is different then the current environment. 

* *--id* The :code:`--id` flag is used to for predicting the directory path of an ID specifc meta-recipe. It is not possible to predict
  the file path of a meta-recipe due to the dynamic nature of the recipe iteself, however, it is possible to predict the directory path. 
  An ID is required when install a meta-recipe, and this ID represents the ID that would be used when install a desired meta-recipe. 
  This ID will be ignored if the path being predicted is NOT for a meta-recipe. Additionaly, if this parameter is not used then the 
  directory path to the non ID specifc meta-recipe will be provided, which is of no use. 


Examples
--------


1. Predict the path of the chromsize file:
++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd predict-path -pn hg19-chromsizes-ggd-v1 -fn hg19-chromsizes-ggd-v1.txt

      <conda root>/share/ggd/Homo_sapiens/hg19/hg19-chromsizes-ggd-v1/1/hg19-chromsizes-ggd-v1.txt


2. Predict the path of the chromsize file in the "data" environment:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd predict-path -pn hg19-chromsizes-ggd-v1 -fn hg19-chromsizes-ggd-v1.txt --prefix data

      <data environment>/share/ggd/Homo_sapiens/hg19/hg19-chromsizes-ggd-v1/1/hg19-chromsizes-ggd-v1.txt


3. Predict the directory path of a GEO meta-recipe:
+++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd predict-path --package-name meta-recipe-geo-accession-geo-v1 --dir-path --id GSE123

     <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/


.. note::

    If you are getting the predicted path for a meta-recipe you need to add the :code:`--id` parameter, otherwise, you will get 
    the directory path to a main meta-recipe, which should never contain any data files. (The wrong path)





