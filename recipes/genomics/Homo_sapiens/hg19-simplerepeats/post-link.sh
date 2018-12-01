#!/bin/bash
set -eo pipefail -o nounset

export CONDA_ROOT=$(conda info --root)

PKG_DIR=`find "$PREFIX/pkgs/" -name "$PKG_NAME-$PKG_VERSION*" | grep "$PKG_VERSION-.*$PKG_BUILDNUM\|$PKG_VERSION\_.*$PKG_BUILDNUM" | grep -v ".tar.bz2"`

export RECIPE_DIR=$CONDA_ROOT/share/ggd/Homo_sapiens/hg19/hg19-simplerepeats/1

if [ -d $RECIPE_DIR ]; then
    rm -r $RECIPE_DIR
fi

mkdir -p $RECIPE_DIR

recipe_env_name="ggd_hg19-simplerepeats"
recipe_env_name="$(echo "$recipe_env_name" | sed 's/-/_/g')"

env_dir=$(conda info --envs | grep "*" | grep -o "\/.*")

activate_dir="$env_dir/etc/conda/activate.d"
deactivate_dir="$env_dir/etc/conda/deactivate.d"

mkdir -p $activate_dir
mkdir -p $deactivate_dir

echo "export $recipe_env_name=$RECIPE_DIR" >> $activate_dir/env_vars.sh
echo "unset $recipe_env_name">> $deactivate_dir/env_vars.sh
ggd show-env

(cd $RECIPE_DIR && bash $PKG_DIR/info/recipe/recipe.sh)

echo 'Recipe successfully built!'
