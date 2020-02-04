#!/bin/bash
set -eo pipefail -o nounset

echo "0" 

if [[ -z $(conda info --envs | grep "*" | grep -o "\/.*") ]]; then
    echo "0.1" 
    export CONDA_ROOT=$(conda info --root)
    env_dir=$CONDA_ROOT
    export RECIPE_DIR=$CONDA_ROOT/share/ggd/Homo_sapiens/GRCh38/grch38-p13-chrom-mapping-ucsc2ensembl-ncbi-v1/1
elif [[ $(conda info --envs | grep "*" | grep -o "\/.*") == "base" ]]; then
    echo "0.2" 
    export CONDA_ROOT=$(conda info --root)
    env_dir=$CONDA_ROOT
    export RECIPE_DIR=$CONDA_ROOT/share/ggd/Homo_sapiens/GRCh38/grch38-p13-chrom-mapping-ucsc2ensembl-ncbi-v1/1
else
    echo "0.3" 
    env_dir=$(conda info --envs | grep "*" | grep -o "\/.*")
    export CONDA_ROOT=$env_dir
    export RECIPE_DIR=$env_dir/share/ggd/Homo_sapiens/GRCh38/grch38-p13-chrom-mapping-ucsc2ensembl-ncbi-v1/1
fi


echo "1" 

PKG_DIR=`find "$CONDA_SOURCE_PREFIX/pkgs/" -name "$PKG_NAME-$PKG_VERSION*" | grep -v ".tar.bz2" |  grep "$PKG_VERSION.*$PKG_BUILDNUM$"`

echo "2" 

if [ -d $RECIPE_DIR ]; then
    rm -r $RECIPE_DIR
fi

echo "3" 

mkdir -p $RECIPE_DIR

echo "4" 

(cd $RECIPE_DIR && bash $PKG_DIR/info/recipe/recipe.sh)

echo "5" 

cd $RECIPE_DIR

echo "6" 

## Iterate over new files and replace file name with data package name and data version  
for f in *; do
    ext="${f#*.}"
    filename="{f%%.*}"
    if [[ ! -f "grch38-p13-chrom-mapping-ucsc2ensembl-ncbi-v1.$ext" ]]  
    then
        (mv $f "grch38-p13-chrom-mapping-ucsc2ensembl-ncbi-v1.$ext")
    fi  
done

echo "7" 

## Add environment variables 
#### File
if [[ `find $RECIPE_DIR -type f -maxdepth 1 | wc -l | sed 's/ //g'` == 1 ]] ## If only one file
then
    recipe_env_file_name="ggd_grch38-p13-chrom-mapping-ucsc2ensembl-ncbi-v1_file"
    recipe_env_file_name="$(echo "$recipe_env_file_name" | sed 's/-/_/g' | sed 's/\./_/g')"
    file_path="$(find $RECIPE_DIR -type f -maxdepth 1)"

elif [[ `find $RECIPE_DIR -type f -maxdepth 1 | wc -l | sed 's/ //g'` == 2 ]] ## If two files
then
    indexed_file=`find $RECIPE_DIR -type f \( -name "*.tbi" -or -name "*.fai" -or -name "*.bai" -or -name "*.crai" -or -name "*.gzi" \) -maxdepth 1`
    if [[ ! -z "$indexed_file" ]] ## If index file exists
    then
        recipe_env_file_name="ggd_grch38-p13-chrom-mapping-ucsc2ensembl-ncbi-v1_file"
        recipe_env_file_name="$(echo "$recipe_env_file_name" | sed 's/-/_/g' | sed 's/\./_/g')"
        file_path="$(echo $indexed_file | sed 's/\.[^.]*$//')" ## remove index extension
    fi
fi 

echo "8" 

#### Dir
recipe_env_dir_name="ggd_grch38-p13-chrom-mapping-ucsc2ensembl-ncbi-v1_dir"
recipe_env_dir_name="$(echo "$recipe_env_dir_name" | sed 's/-/_/g' | sed 's/\./_/g')"

activate_dir="$env_dir/etc/conda/activate.d"
deactivate_dir="$env_dir/etc/conda/deactivate.d"

mkdir -p $activate_dir
mkdir -p $deactivate_dir

echo "export $recipe_env_dir_name=$RECIPE_DIR" >> $activate_dir/env_vars.sh
echo "unset $recipe_env_dir_name">> $deactivate_dir/env_vars.sh

#### File
    ## If the file env variable exists, set the env file var
if [[ ! -z "${recipe_env_file_name:-}" ]] 
then
    echo "export $recipe_env_file_name=$file_path" >> $activate_dir/env_vars.sh
    echo "unset $recipe_env_file_name">> $deactivate_dir/env_vars.sh
fi
    
echo "9" 

echo 'Recipe successfully built!'
