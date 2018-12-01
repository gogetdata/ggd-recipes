#!/bin/bash

set -eo pipefail -o nounset


export PATH=/anaconda/bin:$PATH
conda install htslib gsort


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
            echo -e "\n-> Sucessfully Uploaded\n" 
		fi
    else 
        echo -e "\n-> DONE"
	fi
	set -o nounset

done
