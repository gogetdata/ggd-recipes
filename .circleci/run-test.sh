#!/bin/bash
set -eo pipefail -o nounset

## Export env variable for post-link
export CONDA_SOURCE_PREFIX=$(conda info --root)

CONDA_ROOT=$(conda info --root)
rm -rf $CONDA_ROOT/conda-bld/*

## bz2 location of built recipes (conda-bld/<platform>/<.bz2>) (platform = noarch, linux, macos, etc.)
CHECK_DIR=$CONDA_ROOT/conda-bld/*
rm -rf $CHECK_DIR
mkdir -p $CHECK_DIR

## cleanup
rmbuild() {
    rm -rf $CHECK_DIR
}
trap rmbuild EXIT

## Build/filter all recipes using bioconda-utils build
bioconda-utils build recipes/ config.yaml

echo -e  "\n############################################################"
echo "-> Checking Dependencies"
echo -e "############################################################\n"

recipe_uploaded=false
cached=false
cached_recipes_path=""

for bz2 in $CHECK_DIR/*.bz2; do
    if [[ "$(basename $bz2)" == *".json.bz2" ]]; then
        continue
    fi
    if [[ "$(basename $bz2)" == "*.bz2" ]]; then
        continue
    fi  

    echo "############################################################"
    echo "-> Checking recipe" $(basename $bz2)
    echo "############################################################"
    ggd check-recipe -du $bz2 --dont-add-md5sum-for-checksum  ## md5sum checksum will be tested
    
    ## Upload
    set +o nounset

    ## If on branch master, and there is no pull requests
    if [[ "$CIRCLE_BRANCH" == "master" && -z "$CIRCLE_PULL_REQUEST" ]] ; then
        if [[ "$ANACONDA_GGD_TOKEN" == "" ]]; then
            echo -e "\n-> WARNING:"
            echo '-> $ANACONDA_GGD_TOKEN not set'
        else
            anaconda -t $ANACONDA_GGD_TOKEN upload $bz2
            recipe_uploaded=true
            echo -e "\n-> Successfully Uploaded\n" 

            ## Set for all uploaded packages. Use a condition to restrict which packages are cached and which ones are not
            cache_pkg=true

            if [[ "$cache_pkg" == true ]]; then
                if [[ "$OSTYPE" == linux* ]]; then ##Only cache the linux version
                    echo "############################################################"
                    echo "-> Caching recipe on aws" $(basename $bz2)
                    echo "############################################################"
                    ## FIX THIS BEFORE PUSH AND COMMIT
                    files_path=`(python .circleci/get_tarbz2_file_path.py -t $bz2 -cr $CONDA_ROOT)` 
                    cached_recipes_path=`(python .circleci/aws_upload.py -ak $AWS_ACCESS_KEY_ID -sak $AWS_SECRET_ACCESS_KEY -p $files_path -t $bz2 | tail -n 1)` 
                    cached=true
                    echo -e "\n-> Successfully cached\n"  
                else
                    echo -e "\n-> OSType is not linux. Data Package will not be cached\n"
                fi
            fi
            ##Uninstall local built package
            local_file=$(basename $bz2)
            file_no_ext="${local_file%%.*}"
            file_no_build="${file_no_ext%-*}"
            recipe_name="${file_no_build%-*}"
            conda uninstall $recipe_name -y
        fi
    else 
        echo -e "\n-> DONE"
    fi
    set -o nounset
done

if [[ "$cached" == true ]] ; then

    rm $CHECK_DIR/*.bz2

    ## build the new pacakges
    bioconda-utils build $cached_recipes_path config.yaml

    ## run recipe check and upload
    for bz2 in $CHECK_DIR/*.bz2; do
        if [[ "$(basename $bz2)" == *".json.bz2" ]]; then
            continue
        fi
        if [[ "$(basename $bz2)" == "*.bz2" ]]; then
            continue
        fi

        echo "############################################################"
        echo "-> Checking recipe" $(basename $bz2)
        echo "############################################################"
        ggd check-recipe -du $bz2 --dont-add-md5sum-for-checksum ## md5sum checksum will be tested  

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
fi

if [[ "$recipe_uploaded" == true ]] ; then
    # update channeldata index    
    python .circleci/index_ggd_channel.py -t "/tmp"

    ##TODO: Update Available Packages in ggd docs
fi

