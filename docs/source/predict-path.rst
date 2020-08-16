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

+-----------------------------+---------------------------------------------------------------------------------------+
| ggd predict-path            | Get a predicted install file path for a data package before it is installed.          |
|                             | (Use for workflows, such as Snakemake)                                                |
+=============================+=======================================================================================+
| -h, --help                  | show this help message and exit                                                       | 
+-----------------------------+---------------------------------------------------------------------------------------+
| -c, --channel               | The ggd channel of the recipe to fine. (Deafult = genomics)                           |
+-----------------------------+---------------------------------------------------------------------------------------+
| --prefix                    | (Optional) The name or the full directory path to an                                  |
|                             | conda environment. The predicted path will be based on                                |
|                             | this conda environment. When installing, the data                                     |
|                             | package should also be installed in this environment.                                 |
|                             | (Only needed if not predicting for a path in the                                      |
|                             | current conda environment)                                                            |
+-----------------------------+---------------------------------------------------------------------------------------+
| -pn, --package-name         | **Required** The name of the data package to predict a                                |
|                             | file path for                                                                         |
+-----------------------------+---------------------------------------------------------------------------------------+
| -fn, --file-name            | **Required** The name of the file to predict that path                                |
|                             | for. It is best if you give the full and correct name                                 |
|                             | of the file to predict the path for. If not, ggd will                                 |
|                             | try to identify the right file, but won't guarantee                                   |
|                             | that it is the right file                                                             |
+-----------------------------+---------------------------------------------------------------------------------------+



Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments:

* *-pn:* The :code:`-pn` flag represents the data package name for which to predict a file path for. (NOTE: the file 
  path is for a data file from this data package and not the data package itself)

* *-fn:* The :code:`-fn` flag represents the name of the data file for which to predict the file path for. (NOTE: this is 
  the actual file from the data package to predict the path for) You can use :code:`ggd search` or check the 
  :ref:`Available packages <recipes>` page to get the name of the files provided by the package


Optional arguments:

* *-c:* The :code:`-c` flag represents the ggd channel. The default channel is *genomics*.
   
* *--prefix:* The :code:`--prefix` flag is used to get to the install path for a data file in a specific conda  environment/prefix
  that is different then the current environment. 


Examples
--------


1. Predict the path of the chromsize file:
++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd predict-path -pn hg19-chromsizes-ggd-v1 -fn hg19-chromsizes-ggd-v1.txt

      <conda root>/share/ggd/Homo_sapiens/hg19/hg19-chromsizes-ggd-v1/1/hg19-chromsizes-ggd-v1.txt


1. Predict the path of the chromsize file in the "data" environment:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd predict-path -pn hg19-chromsizes-ggd-v1 -fn hg19-chromsizes-ggd-v1.txt --prefix data

      <data environment>/share/ggd/Homo_sapiens/hg19/hg19-chromsizes-ggd-v1/1/hg19-chromsizes-ggd-v1.txt






