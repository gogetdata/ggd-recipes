#!/bin/bash
set -eo pipefail -o nounset

export CONDA_ROOT=$(conda info --root)

pushd `dirname $0` > /dev/null
HERE=`pwd`
popd > /dev/null

mkdir -p $CONDA_ROOT/share/ggd/Homo_sapiens/GRCh37/grch37-reference-genome
export RECIPE_DIR=$CONDA_ROOT/share/ggd/Homo_sapiens/GRCh37/grch37-reference-genome

recipe_env_name="ggd_grch37-reference-genome"
recipe_env_name="$(echo "$recipe_env_name" | sed 's/-/_/g')"

activate_dir="/scratch/ucgd/lustre/u1072557/a2/etc/conda/activate.d"
deactivate_dir="/scratch/ucgd/lustre/u1072557/a2/etc/conda/deactivate.d"

mkdir -p $activate_dir
mkdir -p $deactivate_dir

echo "export $recipe_env_name=$RECIPE_DIR" >> $activate_dir/env_vars.sh
echo "unset $recipe_env_name">> $deactivate_dir/env_vars.sh
ggd show-env

(cd $RECIPE_DIR && bash $HERE/../info/recipe/recipe.sh)

echo 'SUCCESS!'
