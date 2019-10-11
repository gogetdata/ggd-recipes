#---------------------------------------------------------------------------------------------------------------
## Import Statements
#---------------------------------------------------------------------------------------------------------------
from __future__ import print_function
import sys
import os
import argparse
import boto3
import json
import tarfile
import re
import yaml

#---------------------------------------------------------------------------------------------------------------
## Argument Parser
#---------------------------------------------------------------------------------------------------------------
parser = argparse.ArgumentParser(description="Upload ggd packages to an aws s3 bucket")
parser.add_argument("-ak", "--accesskey", required=True, help="AWS access key")
parser.add_argument("-sak", "--secretaccesskey", required=True, help="AWS secret access key")
parser.add_argument("-r", "--region", help="AWS region")
parser.add_argument("-n", "--name", default="ggd-cache", help="The bucket name. (Default = ggd-cache)")
parser.add_argument("-p", "--path", help = "The directory path to the package files, excluding the files: (Example: /anaconda2/share/ggd/Homo_sapiens/GRCh37/grch37-reference-genome/1/)")
parser.add_argument("-t", "--tarfile", required=True, help = "The tar.bz2 package file")
args = parser.parse_args()


#---------------------------------------------------------------------------------------------------------------
## Methods/Functions
#---------------------------------------------------------------------------------------------------------------

# create_boto3_client
# ===================
# Method used to create an s3 client using the boto3 module
#
# Parameters:
# ----------
# 1) accesskey: AWS access key
# 2) secretaccesskey: AWS secret access key
# 
# Returns:
# 1) The aws boto3 client
def create_boto3_client(accesskey, secretaccesskey):
    client = boto3.client('s3',
        aws_access_key_id=accesskey,
        aws_secret_access_key=secretaccesskey
        #region_name=args.region ## Not specifying a region. (Bucket wasn't created with a specific region, therefore, the endpoint url will be inacurate if using a region
        )
    return(client)


# upload_to_aws
# =============
# Method used to upload the processed files for a specific ggd package to an aws S3 bucket
#
# 1) client: The boto3 aws client
# 2) ggd_recipe_path: The path to the ggd installed directory storing the package files: (example: anaconda2/share/ggd/Homo_sapiens/GRCh37/grch37-esp-variants/1/)
# 3) s3_bucket: The AWS S3 bucket name (Example: ggd-chace)  
#
# Return:
# 1) A list of the urls to access the uploaded files
# 2) A set of ggd_paths where the files were stored
def upload_to_aws(client, ggd_recipe_path, s3_bucket):
    pkg_url_list = []
    ggd_paths = set()
    for root, dirs, files in os.walk(ggd_recipe_path):
        ggd_paths.add(root.split("/share/ggd/")[1]) ## The directory path
        files.sort()
        for name in files:
            key_name_path=os.path.join(root,name).split("/share/ggd/")[1], # set the directory path
            print("\n-> Uploading: %s to aws S3" %(os.path.join(root,name)))
            client.upload_file(
                Filename=os.path.join(root,name),
                Bucket=s3_bucket,
                Key=key_name_path[0],
                ExtraArgs={'ACL': 'public-read'} ## set public read access
                )
            url = '{}/{}/{}'.format(client.meta.endpoint_url, s3_bucket, key_name_path[0])
            pkg_url_list.append(url)
            print("\n-> The file '%s' was uploaded to the aws s3 %s bucket. The url for the file is: %s" %(name,s3_bucket,url))
    return(pkg_url_list, ggd_paths)


# update_meta_yaml
# ================
# Method used to copy the original meta.yaml file from the new/updated package. The meta.yaml
#  file is stored in a .tar.bz2 file created from conda build <pkg>
# The build number will be increased by one. This will help to upload the new pkg to the anaconda 
#  cloud. The tags key will be populated with "uploaded_to_aws"
# 
# Parameters:
# ----------
# 1) tarball_info_object: A tarInfo object from the tarball package. The object represents the meta.yaml file
#                         for the recipe. File comes from a .tar.bz2 file created using conda build <pkg> 
#                          (meta.yaml file location = info/recipe/meta.yaml.template)
# Returns:
# 1) A dictionary representing the updated build number meta.yaml file
def update_meta_yaml(tarball_info_object):
    yaml_dict = yaml.safe_load(tarball_info_object)
    if "cached" in yaml_dict["about"]["tags"]:
        yaml_dict["about"]["tags"]["cached"].append("uploaded_to_aws") 
    else:
        yaml_dict["about"]["tags"]["cached"] = ["uploaded_to_aws"]
    yaml_dict["build"]["number"] += 1
    ## Remove dependencies 
    yaml_dict["requirements"]["build"] = []
    yaml_dict["requirements"]["run"] = []
    return(yaml_dict)


# copy_file_from_tarInfo_Object
# =============================
# Method used to copy a file from a file within a tar.bz2 tarball file 
# 
# Parameters:
# ----------
# 1) tarball_info_object: A tarInfo object from the tarball package.
# 
# Returns:
# 1) A string representing the copied file
def copy_file_from_tarInfo_Object(tarball_info_object):
    file_str = ""
    for line in tarball_info_object:
        file_str += line.decode("utf-8")
    return(file_str)


# make_postlink_str
# =================
# Method used to create a new post-link.sh script. This script will be similar to the original 
#  pkg's post-link script. The major difference is that it will run an cache_recipe.sh script 
#  instead of the original recipe.sh script. This script will contain information on how to 
#  download the processed files stored on an aws S3 bucket. This will speed up the process of 
#  obtaining the pkg files. 
#
# Parmaeters:
# ----------
# 1) ggd_file_paths: A list of ggd_paths to create and where the processed files with be stored
# 2) species_name: The name of the species the pkg is built for
# 3) recipe_name: The name of the recipe
# 4) genome_build: The genome build the pkg is built for
# 5) recipe_version: The recipe version
# 
# Returns:
# 1) A string representing the new postlink.sh script 
def make_postlink_str(ggd_file_paths, species_name, recipe_name, genome_build, recipe_version):
    postlink_str = ""
    postlink_str += """#!/bin/bash
set -eo pipefail -o nounset

if [[ -z $(conda info --envs | grep "*" | grep -o "\/.*") ]]; then
    export CONDA_ROOT=$(conda info --root)
    env_dir=$CONDA_ROOT
    export RECIPE_DIR=$CONDA_ROOT/share/ggd/{species}/{build}/{name}/{version}
elif [[ $(conda info --envs | grep "*" | grep -o "\/.*") == "base" ]]; then
    export CONDA_ROOT=$(conda info --root)
    env_dir=$CONDA_ROOT
    export RECIPE_DIR=$CONDA_ROOT/share/ggd/{species}/{build}/{name}/{version}
else
    env_dir=$(conda info --envs | grep "*" | grep -o "\/.*")
    export CONDA_ROOT=$env_dir
    export RECIPE_DIR=$env_dir/share/ggd/{species}/{build}/{name}/{version}
fi

PKG_DIR=`find "$CONDA_SOURCE_PREFIX/pkgs/" -name "$PKG_NAME-$PKG_VERSION*" | grep -v ".tar.bz2" | grep "$PKG_VERSION.*$PKG_BUILDNUM$"`

if [ -d $RECIPE_DIR ]; then
    rm -r $RECIPE_DIR
fi

mkdir -p $RECIPE_DIR

(cd $RECIPE_DIR && bash $PKG_DIR/info/recipe/cache_recipe.sh)

cd $RECIPE_DIR

## Iterate over new files and replace file name with data package name and data version  
for f in *; do
    ext="${ext_string}"
    filename="{filename_string}"
    if [[ ! -f "{name}.$ext" ]]  
    then
        (mv $f "{name}.$ext")
    fi  
done

## Add environment variables 
#### File
if [[ `find $RECIPE_DIR -type f -maxdepth 1 | wc -l | sed 's/ //g'` == 1 ]] ## If only one file
then
    recipe_env_file_name="ggd_{name}_file"
    recipe_env_file_name="$(echo "$recipe_env_file_name" | sed 's/-/_/g' | sed 's/\./_/g')"
    file_path="$(find $RECIPE_DIR -type f -maxdepth 1)"

elif [[ `find $RECIPE_DIR -type f -maxdepth 1 | wc -l | sed 's/ //g'` == 2 ]] ## If two files
then
    indexed_file=`find $RECIPE_DIR -type f \( -name "*.tbi" -or -name "*.fai" -or -name "*.bai" -or -name "*.crai" -or -name "*.gzi" \) -maxdepth 1` 
    if [[ ! -z "$indexed_file" ]] ## If index file exists
    then
        recipe_env_file_name="ggd_{name}_file"
        recipe_env_file_name="$(echo "$recipe_env_file_name" | sed 's/-/_/g' | sed 's/\./_/g')"
        file_path="$(echo $indexed_file | sed 's/\.[^.]*$//')" ## remove index extension
    fi
fi 

#### Dir
recipe_env_dir_name="ggd_{name}_dir"
recipe_env_dir_name="$(echo "$recipe_env_dir_name" | sed 's/-/_/g' | sed 's/\./_/g')"

activate_dir="$env_dir/etc/conda/activate.d"
deactivate_dir="$env_dir/etc/conda/deactivate.d"

mkdir -p $activate_dir
mkdir -p $deactivate_dir

echo "export $recipe_env_dir_name=$RECIPE_DIR" >> $activate_dir/env_vars.sh
echo "unset $recipe_env_dir_name">> $deactivate_dir/env_vars.sh

#### File
    ## If the file env variable exists, set the env file var
if [[ ! -z "${file_env_var}" ]] 
then
    echo "export $recipe_env_file_name=$file_path" >> $activate_dir/env_vars.sh
    echo "unset $recipe_env_file_name">> $deactivate_dir/env_vars.sh
fi

echo 'Recipe successfully built!'
""".format(species=species_name,
           name=recipe_name,
           build=genome_build,
           version=recipe_version,
           ext_string="{f#*.}", ## Bash get extention. (.bed, .bed.gz, etc.) 
           filename_string="{f%%.*}",
           file_env_var="{recipe_env_file_name:-}")

    return(postlink_str)


# create_cache_recipe
# ===================
# Method used to create a new recipe.sh script which is used to download 
#  already processed ggd recipes from an aws s3 bucket
# 
# Parameters:
#  ---------
# 1) s3_urls: The urls for the processed files stored in an S3 bucket
# 2) s3_bucket_name: The name of the s3 bucket where the files are stored
#
# Returns:
# 1) A string representing the new cache_recipe.sh script
def create_cache_recipe(s3_urls, s3_bucket_name):
    cache_recipe_str = """#! /bin/sh
set -eo pipefail -o nounset

## CONDA_ROOT was exported in post-link.sh and is available for use here. 

"""
    for url in s3_urls:
        filepath = url.split("/{bucket}/".format(bucket = s3_bucket_name))[1]
        filename = filepath.split("/")[-1]
        filepath = "/".join(filepath.split("/")[0:-1])
        cache_recipe_str += "cd $CONDA_ROOT/share/ggd/{file_path}/\n".format(file_path = filepath)
        cache_recipe_str += "curl {new_url} -o {file_name}\n".format(new_url=url, file_name=filename)
        #cache_recipe_str += "wget {new_url}\n".format(new_url=url)
    
    return(cache_recipe_str)
        

# write_file
# ==========
# Method to write a new file for a recipe at a specific location
# 
# Parameters:
# ----------
# 1) file_path: The path to create the file
# 2) file_name: The name of the file
# 3) file_str: The string contaning file contents 
def write_file(file_path,file_name,file_str):
    if not os.path.isdir(file_path):
        print("\n-> Making a new directory: %s" %(file_path)) 
        os.makedirs(file_path)
        
    print("\n-> Writing '%s' to '%s'" %(file_name, file_path))
    with open(os.path.join(file_path, file_name), "w") as newFile:
        for line in file_str:
            newFile.write(line)


# write_yaml
# ==========
# Method to write a new yaml file for a recipe at a specific location
# 
# Parameters:
# ----------
# 1) file_path: The path to create the file
# 2) file_name: The name of the file
# 3) yaml_dict: The dictionary that contains the yaml file 
def write_yaml(file_path, file_name, yaml_dict):
    if not os.path.isdir(file_path):
        print("\n-> Making a new directory: %s" %(file_path)) 
        os.makedirs(file_path)
        
    print("\n-> Writing '%s' to '%s'" %(file_name, file_path))
    with open(os.path.join(file_path, file_name), "a") as newFile:
        for key in sorted(yaml_dict.keys()):
            if key != "about": ## Skip about key for now
                newFile.write(yaml.dump({key:yaml_dict[key]}, default_flow_style=False))
        ## Add in the "about" key 
        newFile.write(yaml.dump({"about":yaml_dict["about"]}, default_flow_style=False))


#---------------------------------------------------------------------------------------------------------------
## Main
#---------------------------------------------------------------------------------------------------------------
## Create aws s3 client
boto3_client = create_boto3_client(args.accesskey, args.secretaccesskey)
## Upload ggd pkg porcessed files to an aws S3 bucket. Get the uploaded file urls and the ggd file paths
pkg_urls, ggd_file_paths_set = upload_to_aws(boto3_client, args.path, args.name)
## Sort the ggd paths 
ggd_paths = list(sorted(ggd_file_paths_set))

## Get the species, genome_build, pkg version, and recipe name 
## Homo_sapiens/GRCh37/grch37-esp-variants/1/ -> ["Homo_sapiens","GRCh37","grch37-esp-variants","1"]
pkg_level_info = ggd_paths[0].split("/") 
pkg_species = pkg_level_info[0] 
pkg_genome_build = pkg_level_info[1]
pkg_name = pkg_level_info[2]
pkg_version = pkg_level_info[3]
print("\n-> Updating the pkg to use aws S3 \n-> Pkg info:\n\tSpecies: %s \n\tGenome_build: %s \
    \n\tPkg name: %s \n\tPkg Version: %s" %(pkg_species, pkg_genome_build, pkg_name, pkg_version))

## Create new file path
cwd = os.getcwd()
new_dir_path = "{currentdir}/tmp-recipe-dir".format(currentdir = cwd)
new_file_path = os.path.join(new_dir_path, pkg_name)

## Open the .tar.bz2 file for the ggd recipe created from conda build <pkg>
with tarfile.open(args.tarfile, "r:bz2") as tarball_file:
    ## Copy package meta.yaml and add 1 to the build number 
    #meta_yaml_str = update_meta_yaml(tarball_file.extractfile(tarball_file.getmember("info/recipe/meta.yaml.template")))
    meta_yaml_dict = update_meta_yaml(tarball_file.extractfile(tarball_file.getmember("info/recipe/meta.yaml.template")))
    write_yaml(new_file_path,"meta.yaml",meta_yaml_dict)
    ## Copy package recipe.sh file
    recipe_str = copy_file_from_tarInfo_Object(tarball_file.extractfile(tarball_file.getmember("info/recipe/recipe.sh")))
    write_file(new_file_path,"recipe.sh",recipe_str)
    ## Make new post-link.sh script
    new_postlink_str = make_postlink_str(ggd_paths, pkg_species, pkg_name, pkg_genome_build, pkg_version)
    write_file(new_file_path,"post-link.sh",new_postlink_str)
    ## Make a new recipe.sh script to download files from aws S3 bucket 
    cache_recipe = create_cache_recipe(pkg_urls, args.name)
    write_file(new_file_path,"cache_recipe.sh",cache_recipe)
    ## Copy package checksums_file.txt file
    checksum_str = copy_file_from_tarInfo_Object(tarball_file.extractfile(tarball_file.getmember("info/recipe/checksums_file.txt")))
    write_file(new_file_path,"checksums_file.txt",checksum_str)

print("\n-> Pkg files uploaded to the aws S3 %s bucket. \n-> A new pkg has been created for installing the pkg using the S3 bucket." %args.name)
print("\n-> DONE!")
print("Path to updated recipe:\n%s" %new_dir_path)
