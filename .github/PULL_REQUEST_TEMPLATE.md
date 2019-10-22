<!--
Please read before submitting a pull requests


Before creating a pull-request please run `ggd check-recipe path/to/recipe-dir/`.
    * If any errors occur, fix them prior to creating a PR
    * Look for:
    ```
    ****************************
    * Successful recipe check! *
    ****************************
    ```
    * Once check-recipe has validated the build, you may submit a PR.
    * NOTE: If you submit a PR prior to a successful validation, your recipe will not pass additional automated testing and will be rejected until the recipe is fixed.
    * Make sure that the processed data files have a header, if appropriate 

The ggd comand line interface can be install via: `pip install -U git+git://github.com/gogetdata/ggd-cli.git`

Automated testing is supported by CircleCI. If your pull-request errors on CircleCI, read the log carefully and fix the errors 

--> 

GGD recipe review is required to merge a pull-request (PR). Once your PR is passing tests on CircleCI and is ready to be merged, add the `please review & merge` label to the PR. NOTE: If you are NOT a member of the gogetdata project (meaning that you can't add this label), add a comment requesting that the label be added. 

* [ ] I have read the [guidelines for ggd data recipes](https://gogetdata.github.io/contribute.html).
* [ ] This PR adds is for a new data recipe.
* [ ] This data recipe **is directly relevant to the biological sciences**. 
* [ ] This PR updates an existing recipe.
* [ ] This PR does something else (explain below).




**I'm submitting a new recipe for species:**
<!-- Type below --> 

## Genome build for the recipe is:
<!-- Type below --> 


**Description of the data and what processing is going on**
<!-- Please provide a detailed summary of the recipe and how it is being processed -->
<!-- Type below --> 


## File type(s):
<!-- Please provide the genomic data file types -->
<!-- Type below --> 


## Data files containe a header:
<!-- If no, please explain why -->
  - [ ] Yes
  - [ ] No






