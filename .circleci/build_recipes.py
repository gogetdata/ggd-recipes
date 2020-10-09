from __future__ import print_function

import argparse
import glob
import io
import os
import subprocess as sp
import sys
from collections import defaultdict
from itertools import chain

import networkx as nx
import requests
import yaml
from conda_build import api

# ---------------------------------------------------------------------------------------------------------------------------------
## Global Variables
# ---------------------------------------------------------------------------------------------------------------------------------

REPODATA_URL = "https://conda.anaconda.org/{channel}/{subdir}/repodata.json"
REPODATA_LABELED_URL = "https://conda.anaconda.org/{channel}/label/{label}/{subdir}/repodata.json"
REPODATA_DEFAULTS_URL = "https://repo.anaconda.com/pkgs/main/{subdir}/repodata.json"


# ---------------------------------------------------------------------------------------------------------------------------------
## Argument Parser
# ---------------------------------------------------------------------------------------------------------------------------------


def arguments():

    p = argparse.ArgumentParser(
        description="Identify and build all ggd recipes that are not currently in any ggd conda channel"
    )

    req = p.add_argument_group("Required Arguments")

    opt = p.add_argument_group("Optional Arguments")

    req.add_argument(
        "--recipe-dir",
        metavar="Base Recipe Directory",
        required=True,
        help="(Required) The base recipe directory to start walking through to identify any ggd recipes. For example, the main 'recipes' folder in the ggd-recipes repo",
    )

    req.add_argument(
        "--config-file",
        metavar="Configuration File",
        required=True,
        help="(Required) Path to the configureation yaml file. This file should contain relevant information such as specific channels",
    )

    opt.add_argument(
        "--packages",
        metavar="Specific Packages to build",
        nargs="*",
        help="(Optional) A single or space seperated list of packages to build. Only these packages will be checked and potentially built",
    )

    opt.add_argument(
        "--blacklist",
        metavar="Black listed recipes",
        help="(Optional) A file with recipes that are blacklisted. That is, recipes to skip build for. This file should contain a single recipe name per line. # comment lines will be ignored.",
    )

    opt.add_argument(
        "--debug",
        action="store_true",
        help="(Optional) Whther or not to print the debug output from conad build to the screen.",
    )

    opt.add_argument(
        "--force-build",
        action="store_true",
        help="(Optional) Whether or not to force all recipes being checked to be built or not. (Default = False).",
    )

    return p.parse_args()


# ---------------------------------------------------------------------------------------------------------------------------------
## Functions/methods
# ---------------------------------------------------------------------------------------------------------------------------------


def parse_backlist_file(file_path):
    """
    parse_backlist_file
    ===================
    Method to parse a file that is provided that represents recipes that should be blacklisted.
    Any lines that start with a '#' or any empty lines will be skipped. This method will get all 
    other lines, and treat any recipes that match the recipes being checked as a blacklisted recipe. 

    Parameters:
    -----------
    1) file_path: (str) The file path to the blacklist file

    Returns:
    ++++++++
    1) A generator of blacklisted items
    """
    assert os.path.isfile(
        file_path
    ), ":ggd:build recipes: !!ERROR!! This blacklist file provided is not a file: '{}' please provide a correct file or remove the --backlist flag".foramt(
        file_path
    )

    try:
        with io.open(file_path, "rt", encoding="utf-8") as blist:
            for line in blist:
                if line[0] != "#" and line.strip():
                    yield os.path.basename(str(line.strip()))
    except IOError as e:
        print(
            ":ggd:build recipes: !!ERROR!! A problem occured trying to read the blacklist file. Fix the error and try again"
        )
        print(str(e))
        sys.exit(1)


def get_all_recipes(base_recipe_folder, packages="*", exclude_recipes=set()):
    """
    get_all_recipes
    ===============

    Method to get all the ggd recipes from a base recipe directory. This method will walk through the directory and once it finds "meta.yaml" files it 
     returns the directory as a reciipe. 

    Parameters:
    -----------
    1) base_recipe_folder: (str) The directory path to the base recipe folder to search for recipes in 
    2) packages: (list) A specific package, a set of packages,  or "*" for all packages to look for 

    Returns:
    ++++++++
    1) A generator with the directory paths that represent the recipes
    """

    ## Identify if the packages are going to be filtered by a set of packages or not
    filter_packages = False
    if packages != "*":
        filter_packages = True

    exclude = False
    if exclude_recipes:
        exclude = True

    ##If the packages argument is a string, convert it to a list
    if isinstance(packages, str):
        packages = set(packages)

    print(
        ":ggd:build recipes: Getting recipe(s) from '{recipe_dir}'. Recipes filtered by: '{p}'".format(
            recipe_dir=base_recipe_folder, p=", ".join(list(packages))
        )
    )

    ## Dir path for walking over
    for recipe_dir in glob.glob(os.path.join(base_recipe_folder, "*")):

        ## Identify all recipes with a meta.yaml file
        for dir_path, dir_names, file_names in os.walk(recipe_dir):

            ## If a recipe has been found
            if "meta.yaml" in file_names:

                ## Exclude any blacklisted recipes
                if exclude:
                    if os.path.basename(dir_path) in exclude_recipes:
                        continue

                ## if filter by package
                if filter_packages:
                    if os.path.basename(dir_path) in packages:
                        yield dir_path

                ## If not filtering by package
                else:
                    yield dir_path


def load_config(config_file):
    """
    load_config
    ===========
    Method to load a the base config file for building recipes. The config file should be a yaml file 

    Parameters:
    ----------
    1) config_file: (str) The file path to the config file for buliding recipes

    Returns:
    ++++++++
    1) A list of channels in the config file
    """

    try:
        config_dict = yaml.safe_load(io.open(config_file, "rt", encoding="utf-8"))

    except IOError as e:

        print(
            ":ggd:build recipes: !!ERROR!! A problem occured trying to read the config file. Fix the error and try again"
        )
        print(str(e))
        sys.exit(1)

    channel_dict = config_dict["channels"]

    return channel_dict


def build_recipes(
    recipe_list, check_channels, force=False, debug=False, n_workers=1, worker_offset=0
):
    """
    build_recipes
    =============
    Controller method used to perpare, check, build, and process each recipe in the recipe list. It will 
     build a DAG with Nodes as recipes and dependencies, and edges connecting recipe to dependencies. It
     removes any cyclic nodes that depend on each other. Identify new or updated recipes that need to 
     be built and build them. 

    Parameters:
    -----------
    1) recipe_list: (str) A list of recieps to check (The directory path of the recipe)
    2) check_channels: (list) A list of channels to check against 
    3) force: (bool) Whether or not to force the recipe to be built even if the same verion and build exits in a channel being checked against (Default = False)
    4) debug: (bool) Whether or not to run 'conda build' in the debug phase. (Default = False)
    5) n_workers: (int) The number of works to use to create subdags. (Default = 1) 
    6) worker_offset: (int) The number to use to offset the n_workers used for subdag creation. (Default = 0)

    Return:
    +++++++
    1) True if all recipes are checked and there are no errors. False otherwise 
    """

    if not recipe_list:
        print(":ggd:build recipes: Nothing to be done")
        return True

    ## create a dag
    dag, name2recipe, recipe2name = build_recipe_dag(recipe_list)

    if not dag:
        print(":ggd:build recipes: Nothing to be done")
        return True

    ## Remove cyclic dependencies in the build job
    ### If current build jobs depend on each other, can't build them
    skip_dependent = defaultdict(list)
    dag = remove_dag_cycles(dag, name2recipe, skip_dependent)

    ## Create subdag workers
    subdag = get_subdags(dag, n_workers, worker_offset)

    if not subdag:
        print(":ggd:build recipes: Nothing to be done")
        return True

    print(
        ":ggd:build recipes: {} recipes to build and test: \n{}".format(
            len(subdag), "\n".join(subdag.nodes())
        )
    )

    ## Filter recipes
    filtered_recipes = [
        (recipe, recipe2name[recipe])
        for package in nx.topological_sort(subdag)
        for recipe in name2recipe[package]
    ]

    ## Get the Repodata for each channel
    repodata_by_channel, actualname_to_idname = get_repodata(check_channels)

    ## Remove defaults channel for now
    if "defaults" in check_channels:
        check_channels.remove("defaults")

    ## Check each recipe
    built_recipes = []
    skipped_recipes = []
    failed_recipes = []

    for recipe, name in filtered_recipes:

        ## Check if the recipe is being skipped
        if name in skip_dependent:
            print(
                (
                    ":ggd:build recipes: SKIPPING BUILD: skipping {} because it depends on {} "
                    " which failed build"
                ).format(recipe, skip_dependent[name])
            )
            skipped_recipes.append(recipe)
            continue

        print(":ggd:build recipes: Determining expected packages for {}".format(recipe))

        ## Check a recipe to see if it is any other channel repodata and if it is if it's version/build is greater then what is in the repo data
        predicted_path = check_recipe_for_build(
            recipe,
            check_channels,
            repodata_by_channel,
            actualname_to_idname,
            force=force,
        )

        ## if no predicted path, skip building this recipe
        if not predicted_path:
            print(
                ":ggd:build recipes: Nothing to be done for recipe '{}'".format(recipe)
            )
            continue

        ## Build the recipe
        success = conda_build_recipe(recipe, check_channels, predicted_path, debug)

        ## Check for a successful recipe build
        if success:
            built_recipes.append(recipe)
            print(
                ":ggd:build recipes: Package recipe located at {}".format(
                    ",".join(predicted_path)
                )
            )

        else:
            failed_recipes.append(recipe)
            for pkg in nx.algorithms.descendants(subdag, name):
                skip_dependent[pkg].append(recipe)

    ## Check for failed recipes
    if failed_recipes:
        print(
            (
                ":ggd:build recipes: BUILD SUMMARY: of {} recipes, "
                "{} failed and {} were skipped. "
            ).format(len(filtered_recipes), len(failed_recipes), len(skipped_recipes))
        )

        if built_recipes:
            print(
                (
                    ":ggd:build recipes: BUILD SUMMARY: Although "
                    "the build process failed, there were {} recipes "
                    "built successfully."
                ).format(len(built_recipes))
            )

        for frecipe in failed_recipes:
            print(":ggd:build recipes: BUILD SUMMARY: FAILED recipe {}".format(frecipe))

        ## Purge the builds
        sp.check_call(["conda", "build", "purge"], stderr=sys.stderr, stdout=sys.stdout)

        return False

    ## IF not failed recipes, prompt for a successful build
    print(
        ":ggd:build recipes: BUILD SUMMARY: SUCCESSFULLY BUILT {} of {} recipes".format(
            len(built_recipes), len(filtered_recipes)
        )
    )

    return True


def conda_build_recipe(recipe, channels, predicted_path, debug=False):
    """
    conda_build_recipe
    ==================
    This method is used to build a single recipe using `conda build`

    Parameters:
    -----------
    1) recipe: (str) The directory path to the recipe to build
    2) channels: (list) A list of conda channels
    3) predicted_path: (str) The file path to the predicted tarball file path once a recipe is built
    4) debug: (bool) Whether or not to run `conda build` in debug mode. (Default = False)

    Return:
    +++++++
    1) True if the recipe is successfully built, False otherwise
    """

    print(":ggd:build recipe: BUILD STARTED for {}".format(recipe))

    ## set up args
    args = ["--override-channels", "--no-anaconda-upload"]

    ## Add changels to args
    for channel in channels + ["local"]:
        args += ["-c", channel]

    ## Get config file
    config = load_conda_build_config()

    ## Check for exclusions
    for file_path in config.exclusive_config_files or []:
        if file_path:
            args += ["-e", file_path]

    ## check for additional configs
    for file_path in config.variant_config_files or []:
        if file_path:
            args += ["-m", file_path]

    ## Get recipe path
    recipe_path = os.path.join(recipe, "meta.yaml")

    if debug:
        cmd = ["conda", "build", "--debug"] + args + [recipe_path]
    else:
        cmd = ["conda", "build"] + args + [recipe_path]

    ## Run conda build
    try:
        sp.check_call(cmd, stderr=sys.stderr, stdout=sys.stdout)
    except Exception as e:
        print(":ggd:build recipes: Build failed for {}".format(recipe))
        print(str(e))
        return False

    ## Check that the predicted tarfile path was created
    for ppath in predicted_path:
        if os.path.exists(ppath) == False or os.path.isfile(ppath) == False:
            print(
                ":ggd:build recipes: !!ERROR!! The predicted tarfile does not exists after building the recipe. The build failed"
            )
            return False

    print(":ggd:build recipes: BUILD SUCCESS: Successfully built {}".format(recipe))
    return True


def get_repodata(check_channels):
    """
    get_repodata
    ============
    Method to get the conda repodata for a list of conda channels 

    Parameters:
    -----------
    1) check_channels: (list) A list of channels to check and get repodata for 

    Returns:
    ++++++++
    1) A dictionary with keys as channels and values as the repodata for that channel starting at the "packages" key.
    """

    print(":ggd:build recipes: Loading repodata for each channel from the config file")

    ## Load the repodata for each channel
    repodata_by_channel = dict()

    name2tar = defaultdict(lambda: defaultdict(set))

    ## Check each channel
    for channel in check_channels:

        ## No repodata for default (local) channel
        if channel == "defaults":
            continue

        ## NOTE: Hardset to noarch right now. This might need to change in the future
        repodata_url = REPODATA_URL.format(channel=channel, subdir="noarch")

        ## Get the repodata from the anaconda url
        try:
            repodata_json = requests.get(repodata_url).json()
        except ValueError as e:
            print(
                ":ggd:build recipes: !!ERROR!! A problem occured loading the repodata for the conda channel: '{}'".format(
                    channel
                )
            )
            print(str(e))
            sys.exit(1)

        ## Add to dict
        repodata_by_channel[channel] = repodata_json["packages"]

        for tar, pkg in repodata_json["packages"].items():
            name = pkg["name"]

            name2tar[channel][name].add(tar)

    return (repodata_by_channel, name2tar)


def load_conda_build_config(platform=None, trim_skip=True):
    """
    load_conda_build_config
    =======================
    Load conda build config while considering global pinnings from conda-forge.

    Parameters:
    -----------
    1) platform: (str) The platform to use. Example: noarch, linux-64, etc. (Default = None)
    2) trim_skip: (bool) What to set conda build config trim skip to. (Default = True)

    Return:
    ++++++
    1) The conda build config object
    """
    config = api.Config(no_download_source=True, set_build_id=False)

    ## Hardset to the bioconda_utils-conda_build_config.yaml file in the .circleci dir
    ### Will need to change this later
    if os.path.basename(os.getcwd()) == "ggd-recipes":
        config.exclusive_config_files = [
            os.path.join(
                os.getcwd(), ".cirlceci", "bioconda_utils-conda_build_config.yaml"
            )
        ]
    else:
        config.exclusive_config_files = []

    for cfg in chain(config.exclusive_config_files, config.variant_config_files or []):
        assert os.path.exists(cfg), "error: {0} does not exist".format(cfg)
    if platform:
        config.platform = platform
    config.trim_skip = trim_skip
    return config


def load_all_meta(recipe, config=None, finalize=True):
    """
    load_all_meta
    =============
    For each environment, yield the rendered meta.yaml.

    Parameters
    ----------
    1) recipe: (str) The directory path to the recipe
    2) config: (str) The config file. (Default = None)
    3) finalize: (bool) If True, do a full conda-build render. Determines exact package builds
                  of build/host dependencies. It involves costly dependency resolution
                  via conda and also download of those packages (to inspect possible
                  run_exports). For fast-running tasks like linting, set to False.
    Returns:
    ++++++++
    1) A list of metadata for each matching recipe
    """

    bypass_env_check = not finalize
    return [
        meta
        for (meta, _, _) in api.render(
            recipe, config=config, finalize=finalize, bypass_env_check=bypass_env_check,
        )
    ]


def load_platform_metas(recipe, finalize=True):
    """
    load_platform_metas
    ===================
    Method to laod conda build config metadata based on the current platoform 

    1) recipe: (str) The directory path to the recipe
    2) finalize: (bool) Used for the load_all_meta() method. Whether or not to run finalize or not. (Default = True)

    Return:
    +++++++
    1) The current system platform
    2) the platfor specific cofig info fro load_all_meta()
    """

    platform = os.environ.get("OSTYPE", sys.platform)

    if platform.startswith("darwin"):
        platform = "osx"
    elif platform == "linux-gnu":
        platform = "linux"

    config = load_conda_build_config(platform=platform)
    return (platform, load_all_meta(recipe, config=config, finalize=finalize))


def check_if_recipe_skippable(recipe, channels, repodata_dict, actualname_to_idname):
    """
    check_if_recipe_skippable
    =========================
    Method used to check if a recipe should be skipped or not. 
    Skip criteria include:
        - If the version of the recipe in the channel repodata is greater than or equal to the query recipe.
        - If the query recipe's version and build are equal to or less than the recipe in the repodata  
    Non-Skip Citeria include:
        - Opposite of skip criteria 
        - If the recipe is not in any channel

    Parameters:
    -----------
    1) recipe: (str) The directory path to the query recipe
    2) channels: (list) A list of channels to check against 
    3) repodata_dict: (dict) A dictionary of repodata by channel (From get_repodata() method)
    4) actualname_to_idname: (dict) Dict of recipe names as keys as id names in the repodata_dict as keys. (From get_repodata() method)

    Returns:
    ++++++++
     - Return True if recipe building is skippable 
     - Return False if recipe building cannot be skipped
    """

    platform, metas = load_platform_metas(recipe, finalize=False)
    # The recipe likely defined skip: True
    if not metas:
        return True

    ## Get each packages name, version, and build number
    packages = set(
        (meta.name(), float(meta.version()), float(meta.build_number() or 0))
        for meta in metas
    )

    for name, version, build_num in packages:

        present = False
        for c in channels:

            ## Check for the recipe in one of the channel's repodata
            if name in actualname_to_idname[c].keys():

                ## Find the newest/highest versioned and build package
                present = True
                cur_version = -1.0
                cur_build = -1.0
                for pkg_tar in actualname_to_idname[c][name]:

                    repo_version = float(repodata_dict[c][pkg_tar]["version"])
                    repo_build_number = float(repodata_dict[c][pkg_tar]["build_number"])

                    ## If version is greater than the previous version, reset values with this package
                    if repo_version > cur_version:
                        cur_version = repo_version
                        cur_build = repo_build_number

                    ## If version is the same but the build number is greater, reset values with this package
                    elif version == cur_version and repo_build_number > cur_build:
                        cur_build = repo_build_number

                ## Check if the query package is newer then what is repoted in the repodata or not
                ## If the query package's version is greater than the best in the repodata, update recipe
                if cur_version < version:
                    return False

                ## If the query package's is the same version but the build number is greater than the best in the repodata, update recipe
                elif cur_version == version and cur_build < build_num:
                    return False

        ## If package not already in the repodata
        if not present:
            return False

        print(
            ":ggd:build recipes: FILTER: not building recipe {} because the version and/or build number match what is already in the channel and not forced".format(
                recipe
            )
        )
        return True


def check_recipe_for_build(
    recipe, check_channels, repodata_by_channel, actualname_to_idname, force=False
):
    """
    check_recipe_for_build
    ======================
    Method used to check if a recipe should be built or not

    Parameters:
    -----------
    1) recipe: (str) The directory path for the recipe in question
    2) check_channels: (list) A list of channels to check against
    3) repodata_by_channel: (dict) A dictionary of repodata by channel (From get_repodata() method)
    4) actualname_to_idname: (dict) Dict of recipe names as keys as id names in the repodata_dict as keys. (From get_repodata() method)
    5) force: (bool) Whether or not to force a recipe to be built even if it should be skipped. "Force build" (Default = False)

    Return:
    +++++++
     - Any empty list if the recipe should be skipped 
     - A list of predicted tarball file paths for the build recipe if the recipe should be built
    """

    if not force:
        ## Check for recipes that could be skipped
        if check_if_recipe_skippable(
            recipe, check_channels, repodata_by_channel, actualname_to_idname
        ):
            # NB: If we skip early here, we don't detect possible divergent builds.
            return []

    ## Use conda build to get meta info
    platform, metas = load_platform_metas(recipe, finalize=True)

    # The recipe likely defined skip: True
    if not metas:
        return []

    ## Get the predicted tarball path
    predicted_tar_paths = list(
        chain.from_iterable(api.get_output_file_paths(meta) for meta in metas)
    )

    ## Return predicted tarball file path
    return predicted_tar_paths


def remove_dag_cycles(dag, name2recipes, skip_dependent):
    """
    remove_dag_cycles
    =================
    Method to remove cycles in the dag. Cycles happen when mutliple recipes as nodes depend on each other. 

    Parameters:
    -----------
    1) dag: (networkx.DiGraph() object) The dag create from build_recipe_dag() 
    2) name2receips: (dict) A dictionary where keys are recipe names and values are sets of recipe paths
    3) skip_dependent: (dict) A dictionary with recipes that should be skipped. (To be filled with this method)

    Returns:
    ++++++++
    1) an updated dag with cyclic nodes removed
    """

    nodes_in_cycles = set()
    for cycle in list(nx.simple_cycles(dag)):
        print(
            ":ggd:build recipes: !!BUILD ERROR!! dependency cycle found for: {}".format(
                cycle
            )
        )
        nodes_in_cycles.update(cycle)

    for name in sorted(nodes_in_cycles):

        fail_recipes = sorted(name2recipes[name])
        print(
            (
                ":ggd:build recipes: !!BUILD ERROR!! cannot build recipes for {} since "
                "it cyclically depends on other packages in the current build job. "
                "Failed recipes: %s"
            ).format(name, fail_recipes)
        )

        for node in nx.algorithms.descendants(dag, name):
            if node not in nodes_in_cycles:
                skip_dependent[node].extend(cycle_fail_recipes)

    return dag.subgraph(name for name in dag if name not in nodes_in_cycles)


def get_subdags(dag, n_workers, worker_offset):
    """
    get_subdags
    ===========
    Method to create subdags from the main dag based on the number or workers available

    Parameters:
    -----------
    1) dag: (networkx.DiGraph() object) The recipe dag
    2) n_workers: (int) The number of workers
    3) worker_offset: (int) The worker offset 

    Returns:
    ++++++++
    1) the subdags 
    """

    if n_workers > 1 and worker_offset >= n_workers:
        raise ValueError(
            "n-workers is less than the worker-offset given! "
            "Either decrease --n-workers or decrease --worker-offset!"
        )

    # Get connected subdags and sort by nodes
    if n_workers > 1:
        root_nodes = sorted([k for k, v in dag.in_degree().items() if v == 0])
        nodes = set()
        found = set()
        for idx, root_node in enumerate(root_nodes):
            # Flatten the nested list
            children = itertools.chain(*nx.dfs_successors(dag, root_node).values())
            # This is the only obvious way of ensuring that all nodes are included
            # in exactly 1 subgraph
            found.add(root_node)
            if idx % n_workers == worker_offset:
                nodes.add(root_node)
                for child in children:
                    if child not in found:
                        nodes.add(child)
                        found.add(child)
            else:
                for child in children:
                    found.add(child)
        subdags = dag.subgraph(list(nodes))
        print(
            ":ggd:build recipes: Building and testing sub-DAGs {} in each group of {}, which is {} packages".format(
                worker_offset, n_workers, len(subdags.nodes())
            )
        )
    else:
        subdags = dag

    return subdags


def build_recipe_dag(recipe_list, restricted=True):
    """
    build_recipe_dag
    ================
    Method to build the DAG for recipes. Nodes represent the recipes and their dependencies, while edges connect the recipe nodes 
     to their dependencies. (build or host deps)

    Parameters:
    -----------
    1) recipe_list: (list) A list of recipes that to build the DAG for 
    2) restricted: (bool) Whether or not to restrict the final list of recipes to recipes only (True) or to include their deps as well (False)

    Returns:
    ++++++++
    1) The DAG
    2) name2recipe_dict: (dict) A dictionary with names of recipes as keys, and sets of recipe paths as values
    3) recipe2name_dict: (dict) A dictionary with recipe path as keys and names as values
    """

    print(":ggd:build recipes: Generating recipe DAG")

    name2recipe_dict = defaultdict(set)
    recipe2name_dict = defaultdict(str)

    ## Create a dag
    dag = nx.DiGraph()

    ## For each recipe, update the dag and update the name2recipe_dict
    for recipe in recipe_list:
        recipe_path = os.path.join(recipe, "meta.yaml")
        recipe_meta = yaml.safe_load(io.open(recipe_path, "rt", encoding="utf-8"))

        ## get a dictionary to match recipe name to recipe dir
        recipe_name = recipe_meta["package"]["name"]
        name2recipe_dict[recipe_name].update([recipe])

        ## create another dict for recipe to name
        recipe2name_dict[recipe] = recipe_name

        ## Add name as a node to the graph
        dag.add_node(recipe_name)

    ## Check deps
    for recipe in recipe_list:
        recipe_path = os.path.join(recipe, "meta.yaml")
        recipe_meta = yaml.safe_load(io.open(recipe_path, "rt", encoding="utf-8"))

        ## Get deps
        if (
            "build" in recipe_meta["requirements"]
            and recipe_meta["requirements"]["build"]
        ):
            ## If the build reqs are in the current recipe list or the restricted is set to False, add the dep
            build_reqs = [
                x
                for x in recipe_meta["requirements"]["build"]
                if x in name2recipe_dict or not restricted
            ]
        else:
            build_reqs = []

        if "run" in recipe_meta["requirements"] and recipe_meta["requirements"]["run"]:
            run_reqs = [
                x
                for x in recipe_meta["requirements"]["run"]
                if x in name2recipe_dict or not restricted
            ]
        else:
            run_reqs = []

        if (
            "host" in recipe_meta["requirements"]
            and recipe_meta["requirements"]["host"]
        ):
            host_reqs = [
                x
                for x in recipe_meta["requirements"]["host"]
                if x in name2recipe_dict or not restricted
            ]
        else:
            host_reqs = []

        ## Add deps as edges to node
        dag.add_edges_from((dep, recipe_name) for dep in set(build_reqs + host_reqs))

    return (dag, name2recipe_dict, recipe2name_dict)


# ---------------------------------------------------------------------------------------------------------------------------------
## Main
# ---------------------------------------------------------------------------------------------------------------------------------


def main():

    args = arguments()

    ## Get blacklisted recipes
    blacklist_recipes = set()
    if args.blacklist:
        blacklist_recipes = set(parse_backlist_file(args.blacklist))
        print(
            ":ggd:build recipes: The following recipes are being blacklisted: {}".format(
                ", ".join(list(blacklist_recipes))
            )
        )

    ## Get a list of ggd recipes
    print(":ggd:build recipes: Gathering ggd recipes")
    recipes = list(
        get_all_recipes(
            args.recipe_dir, args.packages if args.packages else "*", blacklist_recipes
        )
    )

    print(":ggd:build recipes: Considering {} ggd recipes".format(len(recipes)))

    ## Load the configuration file
    print(":ggd:build recipes: loading config file".format(len(recipes)))

    channels = load_config(args.config_file)

    print(
        ":ggd:build recipes: channels from config file: {}".format(", ".join(channels))
    )

    ## Build the recipes
    build_recipes(recipes, channels, debug=args.debug)


if __name__ == "__main__":

    sys.exit(main() or 0)
