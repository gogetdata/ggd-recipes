.. _snakemake_workflow:

Snakemake Workflow with GGD
===========================

[:ref:`Click here to return to the home page <home-page>`]

This simple example shows how to use GGD within the workflow process to dynamically maintain and use GGD data packages 
during the run-time of a Snakemake workflow. Additionally, it highlights the use of meta-recipes in a workflow, but 
it should be noted that this type of process also works with normal GGD data packages. 

This process will use a simple :code:`config.yml` file, a :code:`Snakefile`, and an R script named :code:`expression_analysis.R`. 

For information on Snakemake workflows see the `Snakemake docs <https://snakemake.readthedocs.io/en/stable/>`_.

**Description:**
This workflow takes a group of related samples as a **Series** record (GSE) from the Gene Expression Omnibus (GEO) database and uses 
the matrix file of samples to plot a few simple expression stats. It uses an R script, available below, to extract information from the 
matrix file and run the analyses. The GSE matrix file is obtained using the ggd meta-recipe :code:`meta-recipe-geo-accession-geo-v1`.

This simple workflow can be run with any GSE GEO accession ID. 

Workflow Files
--------------

**config.yml**

  - Here, we set the *conda_prefix* variable to be the prefix where we want the data files to be installed. We call this 
    prefix :code:`ggd_data`. (This prefix should be the name of the conda environment where you want to store GGD data) 
  
  - We also designate the ggd_recipes we want to use. Specifically, we want to use the GEO meta-recipe named 
    :code:`meta-recipe-geo-accession-geo-v1` with the meta-recipe ID :code:`GSE1234`. The power of this approach is that 
    multiple recipe or meta-recipes can be used during the process. For example, the *id* key below could be set to a list
    of GEO GSE IDs and used to install and use each ID in the workflow process. 

  - A simple change of this ID would allow this Snakemake workflow to work with any GEO GSE ID.

.. code-block:: bash

    conda_prefix: "ggd_data" 

    ggd_recipes:
      name: "meta-recipe-geo-accession-geo-v1"
      id: "GSE1234"

**Snakefile**

  - Here we load the config file and grab the config information from the config.yml file
  
  - We use :code:`ggd predict-path` to predict the **directory path** where we would expect the data for the ID specific 
    meta-recipe to be installed. 

    .. note:: 

        The :code:`predict-path` command can predict the extract file path of the intended file if installing a normal ggd
        data package, however, only the directory path is able to be predicted for meta-recipes. However, for this workflow
        we know that general pattern of the intended data file, so we can use that pattern along with the ID to get the 
        specific path we expect. 

  - We get the expected file path of the *matrix* file using the predicted directory path and the ID specific matrix file pattern.

  - We set up the rules of the Snakemake workflow, which include:

    - Using GGD to install the ID specific meta-recipe
    - Using the provided R script to calculate and plot statistics for that ID specific meta-recipe.

  .. note::

    This example could be expanded to many ID specific meta-recipes, where the workflow would check and install each meta-recipe 
    and create the output for that meta-recipe.


.. code-block:: python

    import subprocess as sp
    import os

    configfile: "config.yml"

    CONDA_PREFIX = config["conda_prefix"]
    ggd_recipe = config["ggd_recipes"]["name"]
    recipe_id = config["ggd_recipes"]["id"]

    ## Get the directory path for the expected file 
    dir_path = sp.check_output(["ggd", 
                             "predict-path", 
                             "--prefix", 
                             CONDA_PREFIX, 
                             "-pn", 
                             ggd_recipe, 
                             "--id",
                             recipe_id,
                             "--dir-path"
                             ]
                            ).strip().decode("utf-8")

    ## File path of the matrix file
    matrix_file = os.path.join(dir_path,"{}_series_matrix.txt.gz".format(recipe_id)) 

    ## Rules
    rule all:
      input:
        "{}_stats.pdf".format(recipe_id)


    ## Get a few stats from the GSE matrix
    rule get_stats:
      input:
        matrix_file
      output:
        "{}_stats.pdf".format(recipe_id)
      shell:
        """
        Rscript expression_analysis.R {recipe_id} {matrix_file} 
        """
     
    ## Get the GEO GSE matrix file using the GGD GEO meta-recipe
    rule get_matrix_file:
      input:
      output:
        matrix_file
      shell:
        """
        ## If the path dir path exists but not the file, remove the dir
        if [ -d {dir_path} ] && [ ! -d {matrix_file} ] 
        then 
            rm -r {dir_path}
        fi

        ## Install ggd data package
        ggd install  --prefix {CONDA_PREFIX} {ggd_recipe} --id {recipe_id}



**expression_analysis.R**

  - This R script is a simple R script that will take an GSE GEO ID along with the  associated  matrix file path and use the data within that matrix to 
    calculate and plot simple expression statistics.

  - The plots from this script are output as: <ID>_stats.pdf
  
  - Examples of the output from this R script, and the workflow, are available below.

.. code-block:: R

    ## Default repo
    local({r <- getOption("repos")
        r["CRAN"] <- "http://cran.us.r-project.org" 
        options(repos=r)
    })

    if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")

    BiocManager::install("GEOquery", quietly = TRUE )

    install.packages(c("maptools","umap"))

    library(GEOquery)
    library(limma)
    library(umap)
    library(maptools) 

    args = commandArgs(trailingOnly=TRUE)

    id = args[1]
    matrix_file = args[2] 

    ## Load local isntalled matrix
    gset = getGEO(filename = matrix_file, GSEMatrix =TRUE, getGPL=FALSE)

    ## Number of samples:
    nsamples = length(gset$channel_count)

    ex = exprs(gset)

    # log2 transform
    qx = as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
    LogC = (qx[5] > 100) ||
              (qx[6]-qx[1] > 50 && qx[2] > 0)
    if (LogC) { ex[which(ex <= 0)] = NaN
      ex = log2(ex) }

    # box-and-whisker plot
    pdf(paste(id,"_stats",".pdf", sep = ""))
    par(mar=c(7,4,2,1))
    title = paste (id, "/", annotation(gset), sep ="")
    boxplot(ex, boxwex=0.7, notch=T, main=title, outline=FALSE, las=2)

    # expression value distribution plot
    par(mar=c(4,4,2,1))
    title = paste (id, "/", annotation(gset), " value distribution", sep ="")
    plotDensities(ex, main=title, legend=F)

    # mean-variance trend
    ex = na.omit(ex) # eliminate rows with NAs
    plotSA(lmFit(ex), main=paste("Mean variance trend,",id, sep = " "))

    # UMAP plot (multi-dimensional scaling)
    ex = ex[!duplicated(ex), ]  # remove duplicates
    ump = umap(t(ex), n_neighbors = nsamples, random_state = 123)
    plot(ump$layout, main=paste("UMAP plot, nbrs=",nsamples,sep= " "), xlab="", ylab="", pch=20, cex=1.5)

    # point labels without overlaps
    pointLabel(ump$layout, labels = rownames(ump$layout), method="SANN", cex=0.6)
    dev.off()


**software requirements**

  - below is a list of the software requirements needed in order to run the above Snakemake workflow. (These are requirements that can and should 
    be installed using conda)

.. code-block:: bash

    ggd
    python=3
    r-essentials
    snakemake


Alternative Approaches 
----------------------

As stated previously, this is a simple workflow to show how one could use GGD within a workflow. 

To modify this workflow for a normal ggd recipe, not a meta-recipe, one would use :code:`ggd predict path` with the :code:`--file-name` parameter
added. This will give the file path rather then the directory path, which will reduce any additional steps. 

Other options for using GGD could be to have the data previously installed and provided either the GGD generated environment variables for the files 
or the file paths before running the workflow. One could also use :code:`ggd get-files` command during the workflow processes to get any installed ggd 
data file without having to know before hand where the file is installed. 

Containers such as Docker containers or Singularity containers are also options that can be used that are not covered here. 

GGD can be used in many different ways, and we encourage anyone that wants to use GGD for a workflow to experiment with the different options and find the 
solution that works best for your workflow needs. 


Workflow Output Examples:
-------------------------

Here are two examples of running the above workflow with two randomly picked GEO GSE IDs:

1. **GSE1234_stats.pdf**

    :pdfembed:`src:_static/GSE1234_stats.pdf, height:800, width:800, align:middle`


2. **GSE57214_stats.pdf**

    :pdfembed:`src:_static/GSE57214_stats.pdf, height:800, width:800, align:middle`





