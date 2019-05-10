## Clean up build dir
CHECK_DIR=$1
cached_recipes_path=$2
export PATH=/anaconda/bin:$PATH

which check-sort-order
which anaconda

rm $CHECK_DIR/*.bz2
## build the new pacakges
echo -e "\n-> cached dirs:\n"
echo "$cached_recipes_path"
bioconda-utils build $cached_recipes_path config.yaml
## run recipe check and upload
for bz2 in $CHECK_DIR/*.bz2; do
    if [[ "$(basename $bz2)" == "repodata.json.bz2" ]]; then
        continue
    fi  
    if [[ "$(basename $bz2)" == "*.bz2" ]]; then
        continue
    fi  

    echo "############################################################"
    echo "-> Checking recipe" $(basename $bz2)
    echo "############################################################"
    ggd check-recipe $bz2

    ## Upload
    set +o nounset

    ## If on branch master, and there is no pull requests
    if [[ "$CIRCLE_BRANCH" == "master" && -z "$CIRCLE_PULL_REQUEST" ]] ; then
        if [[ "$ANACONDA_GGD_TOKEN" == "" ]]; then
            echo -e "\n-> WARNING:"
            echo '-> $ANACONDA_GGD_TOKEN not set'
        else
            anaconda -t $ANACONDA_GGD_TOKEN upload $bz2
            echo -e "\n-> Successfully Uploaded\n" 
        fi  
    fi  
done
