#!/bin/bash

TMPDIR=${TMPDIR:-/tmp/}

set -eo pipefail -o nounset

[[ -z $ANACONDA_GGD_TOKEN ]] && (echo "ANACONDA_GGD_TOKEN not found!!!"; sleep 2);

export PATH=/anaconda/bin:$PATH
#check-sort-order --help
conda install htslib gsort
#gsort --help



CONDA_ROOT=$(conda info --root)
rm -rf $CONDA_ROOT/conda-bld/*

CHECK_DIR=$TMPDIR/builds.$$/
rm -rf $CHECK_DIR
mkdir -p $CHECK_DIR

## cleanup
rmbuild() {
	rm -rf $CHECK_DIR
}
trap rmbuild EXIT

conda-build-all \
	--inspect-channels=ggd-alpha \
	--artefact-directory $CHECK_DIR \
	recipes/

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
	anaconda -t $ANACONDA_GGD_TOKEN upload $bz2
done
