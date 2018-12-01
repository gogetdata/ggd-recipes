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

echo "############################################################"
echo "############################################################"
echo "Checked Dependencies"
echo "############################################################"
echo "############################################################"

for bz2 in $CHECK_DIR/*.bz2; do
	if [[ "$(basename $bz2)" == "repodata.json.bz2" ]]; then
        continue
    fi
	if [[ "$(basename $bz2)" == "*.bz2" ]]; then
		continue
	fi

	echo "############################################################"
	echo "############################################################"
	echo "Checking recipe" $(basename $bz2)
	echo "############################################################"
	echo "############################################################"
	ggd check-recipe $bz2

	# upload
	set +o nounset
	if [[ "$TRAVIS_BRANCH" == "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
		if [[ "$ANACONDA_GGD_TOKEN" == "" ]]; then
			echo "\n> WARNING:"
			echo '> $ANACONDA_GGD_TOKEN not set'
		else
			anaconda -t $ANACONDA_GGD_TOKEN upload $bz2
		fi
	fi
	set -o nounset

done
