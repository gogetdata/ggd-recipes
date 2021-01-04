.. _workflows:

Using GGD in Workflows 
======================

[:ref:`Click here to return to the home page <home-page>`]


GGD and Workflows 
+++++++++++++++++

Another advantage of GGD is its ability to be used in different workflows. These workflows can range from simple to complex, as well as from a bash 
script style workflow to more advance worflow managers like Snakemake and Nextflow. 

It is customary that data is required and used during a workflow. Rather then having to store and transmit that data along with a workflow, one 
could create the workflow with GGD data packages as dependencies and allow GGD to dynamically provide the data to the workflow. 

GGD can be used before running a workflow or during the workflow process. Additionaly, data recipes can be installed into a Docker or Singularity 
container, where a workflow like Netxflow uses the conda software packages and the GGD data packages in the container during the workflow process. 
GGD can be used during the workflow to install the required package into a specific environment if those packages are not yet installed. This allows 
versitlity in the use of GGD for many types of workflows. 

Provided below are two examples of using GGD in a workflow. These are two simple exmaples and don't fully show the extent of what can be done with GGD 
wihtin a workflow, but rather stand as starting examples of what can be done. 


:ref:`Snakemake Workflow Example<snakemake_workflow>`
+++++++++++++++++++++++++++++++++++++++++++++++++++++

:ref:`Nextflow Workflow Example<nextflow_workflow>`
+++++++++++++++++++++++++++++++++++++++++++++++++++



Contents:

.. toctree::
    :maxdepth: 2


    snakemake_workflow
    nextflow_workflow




