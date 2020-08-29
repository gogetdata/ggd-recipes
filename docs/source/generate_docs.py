import os
import os.path as op
import yaml
import copy
import json
from collections import defaultdict
from jinja2.sandbox import SandboxedEnvironment 
from sphinx.util import logging as sphinx_logging
from sphinx.util import status_iterator
from sphinx.util.parallel import ParallelTasks, parallel_available, make_chunks
from sphinx.util.rst import escape as rst_escape
from sphinx.util.osutil import ensuredir
from sphinx.jinja2glue import BuiltinTemplateLoader
from docutils.statemachine import StringList
from ggd.utils import get_ggd_channels ,get_species 
from collections import defaultdict



# Aquire a logger
try:
    logger = sphinx_logging.getLogger(__name__)
except AttributeError:  # not running within sphinx
    import logging
    logger = logging.getLogger(__name__)


BASE_DIR = op.dirname(op.abspath(__file__))
RECIPE_DIR = op.join(op.dirname(BASE_DIR), 'ggd-recipes', 'recipes')
OUTPUT_DIR = op.join(BASE_DIR, 'recipes')
GGD_GITHUB = "https://github.com/gogetdata/ggd-recipes/tree/master/recipes/"




def as_extlink_filter(text):
    """Jinja2 filter converting identifier (list) to extlink format

    Args:
      text: may be string or list of strings

    >>> as_extlink_filter("biotools:abyss")
    "biotools: :biotool:`abyss`"

    >>> as_extlink_filter(["biotools:abyss", "doi:123"])
    "biotools: :biotool:`abyss`, doi: :doi:`123`"
    """
    def fmt(text):
        assert isinstance(text, str), "identifier has to be a string"
        text = text.split(":", 1)
        assert len(text) == 2, "identifier needs at least one colon"
        return "{0}: :{0}:`{1}`".format(*text)

    assert isinstance(text, list), "identifiers have to be given as list"

    return list(map(fmt, text))


def underline_filter(text):
    """Jinja2 filter adding =-underline to row of text

    >>> underline_filter("headline")
    "headline\n========"
    """
    return text + "\n" + "=" * len(text)


def rst_escape_filter(text):
    """Jinja2 filter escaping RST symbols in text
    >>> rst_excape_filter("running `cmd.sh`")
    "running \`cmd.sh\`"
    """
    if text:
        return rst_escape(text)
    return text


def escape_filter(text):
    """Jinja2 filter escaping RST symbols in text

    >>> excape_filter("running `cmd.sh`")
    "running \`cmd.sh\`"
    """
    if text:
        return rst_escape(text)
    return text

def prefixes_filter(text, split):
    """Jinja2 filter"""
    path = []
    for part in text.split(split):
        path.append(part)
        yield {'path': split.join(path), 'part': part}


def rst_link_filter(text, url):
    """Jinja2 filter creating RST link
    >>> rst_link_filter("bla", "https://somewhere")
    "`bla <https://somewhere>`_"
    """
    if url:
        return "`{} <{}>`_".format(text, url)
    return text


class Renderer(object):
    """Jinja2 template renderer

    - Loads and caches templates from paths configured in conf.py
    - Makes additional jinja filters available:
      - underline -- turn text into a RSt level 1 headline
      - escape -- escape RST special characters
      - as_extlink -- convert (list of) identifiers to extlink references
    """
    def __init__(self, app):
        template_loader = BuiltinTemplateLoader()
        template_loader.init(app.builder)
        template_env = SandboxedEnvironment(loader=template_loader)
        template_env.filters['rst_escape'] = rst_escape_filter
        template_env.filters['underline'] = underline_filter
        template_env.filters['as_extlink'] = as_extlink_filter
        template_env.filters['prefixes'] = prefixes_filter
        template_env.filters['rst_link'] = rst_link_filter
        self.env = template_env
        self.templates = {}

    def render(self, template_name, context):
        """Render a template file to string

        Args:
          template_name: Name of template file
          context: dictionary to pass to jinja
        """
        try:
            template = self.templates[template_name]
        except KeyError:
            template = self.env.get_template(template_name)
            self.templates[template_name] = template

        return template.render(**context)

    def render_to_file(self, file_name, template_name, context):
        """Render a template file to a file

        Ensures that target directories exist and only writes
        the file if the content has changed.

        Args:
          file_name: Target file name
          template_name: Name of template file
          context: dictionary to pass to jinja

        Returns:
          True if a file was written
        """
        content = self.render(template_name, context)
        # skip if exists and unchanged:
        if os.path.exists(file_name):
            with open(file_name, encoding="utf-8") as f:
                if f.read() == content:
                    return False  # unchanged
        ensuredir(op.dirname(file_name))

        with open(file_name, "wb") as f:
            f.write(content.encode("utf-8"))
        return True


def generate_readme(recipe_dict, renderer):
    """Generates README.rst for the recipe in folder

    Args:
      folder: Toplevel folder name in recipes directory
      renderer: Renderer object

    Returns:
      List of template_options for each concurrent version for
      which meta.yaml files exist in the recipe folder and its
      subfolders
    """

    # Read the meta.yaml file(s)
    try:
        ## Get recipe 
        recipe_path = op.join(recipe_dict["meta_path"], "meta.yaml")
        assert op.exists(recipe_path)
        ## Get the recipe
        recipe = yaml.safe_load(open(recipe_path))
    except AssertionError as e:
        print("meta.yaml file missing for {}".format(op.join(RECIPE_DIR,recipe_dict["meta_path"])))
        print(str(e))
        sys.exit(1)
    except IOError as e:
        print("Can't open meta.yaml file for {}".format(op.join(RECIPE_DIR,recipe_dict["meta_path"])))
        print(str(e))
        sys.exit(1)

    # Format the README
    name = recipe["package"]["name"]

    template_options = {
        'name': name,
        'version': recipe["package"]["version"],
        'summary': recipe["about"]["summary"],
        'species':  recipe["about"]["identifiers"]["species"],
        'genome_build':  recipe["about"]["identifiers"]["genome-build"],
        'ggd_channel': recipe["about"]["tags"]["ggd-channel"],
        'recipe_author': recipe["extra"]["authors"],
        'keywords': recipe["about"]["keywords"],
        'data_provider': recipe["about"]["tags"]["data-provider"] if "data-provider" in recipe["about"]["tags"] else "NA",
        'data_version': recipe["about"]["tags"]["data-version"] if "data-version" in recipe["about"]["tags"] else "NA",
        'file_type': recipe["about"]["tags"]["file-type"] if "file-type" in recipe["about"]["tags"] else ["NA"],
        'final_files': recipe["about"]["tags"]["final-files"] if "final-files" in recipe["about"]["tags"] else ["NA"],
        'final_file_sizes': ["{}: **{}**".format(name,size) for name, size in recipe["about"]["tags"]["final-file-sizes"].items()] if "final-file-sizes" in recipe["about"]["tags"] else ["NA"],
        'coordinate_base': recipe["about"]["tags"]["genomic-coordinate-base"] if "genomic-coordinate-base" in recipe["about"]["tags"] else "NA", 
        "deps": sorted(recipe["requirements"]["run"]) if recipe["requirements"]["run"] is not None else ["NA"],
        'gh_recipes': 'https://github.com/gogetdata/ggd-recipes/tree/master/recipes/',
        'recipe_path': op.join(recipe_dict["channel"], recipe_dict["species"], recipe_dict["build"], name),
        'Package': '<a href="recipes/{c}/{s}/{b}/{n}/README.html">{n}</a>'.format(c=recipe_dict["channel"],s=recipe_dict["species"],b=recipe_dict["build"],n=name),
        'prefix_install_capable': "**Prefix install enabled:** *False*. This package has not been set up to use the ``--prefix`` flag when running ggd install. Once installed, this package will work with other ggd tools that use ``--prefix`` flag." if "final-files" not in recipe["about"]["tags"] else "**Prefix install enabled:** *True*"
    }

        
    renderer.render_to_file(
        op.join(OUTPUT_DIR, recipe_dict["channel"], recipe_dict["species"], recipe_dict["build"], name ,'README.rst'),
        'readme.rst_t',
        template_options)

    return template_options

def generate_recipes(app):
    """
    Go through every folder in the `ggd-recipes/recipes` dir,
    have a README.rst file generated and generate a recipes.rst from
    the collected data.
    """
    renderer = Renderer(app)

    recipes = []

    ## Get each folder that contains a meat.yaml file
    recipe_dirs = []

    ## Get Species, Genome Builds, and
    species_build_dict = get_species(full_dict = True)
    ggd_channels = set(get_ggd_channels())

    ## Get recipe info
    curr_channel = ""
    curr_species = ""
    curr_genome_build = ""

    ## Get all sub_path combinations for channel, species, and build
    sub_paths = {op.join(channel,species,build): {"channel":channel, "species": species, "build": build} for channel in ggd_channels for species, builds in species_build_dict.items() for build in builds}

    for sub_path, info_dict in sub_paths.items():
        for root, dirs, files in os.walk(op.join(RECIPE_DIR,sub_path)):
            ## Get all paths to the yaml file
            if "meta.yaml" in files:
                info = copy.deepcopy(info_dict)
                info["meta_path"] = root
                recipe_dirs.append(info)

    if parallel_available and len(recipe_dirs) > 5:
        nproc = app.parallel
    else:
        nproc = 1

    if nproc == 1:
        for recipe_dict in status_iterator(
                recipe_dirs,
                'Generating package READMEs...',
                "purple", len(recipe_dirs), app.verbosity):
            recipes.append(generate_readme(recipe_dict, renderer))
    else:
        tasks = ParallelTasks(nproc)
        chunks = make_chunks(recipe_dirs, nproc)

        def process_chunk(chunk):
            _recipes = []
            for recipe_dict in chunk:
                _recipes.extend(generate_readme(recipe_dict, renderer))
            return _recipes

        def merge_chunk(chunk, res):
            recipes.extend(res)

        for chunk in status_iterator(
                chunks,
                'Generating package READMEs with {} threads...'.format(nproc),
                "purple", len(chunks), app.verbosity):
            tasks.add_task(process_chunk, chunk, merge_chunk)
        logger.info("waiting for workers...")
        tasks.join()

    
    ## Create json file based on genome, species, and genome build
    pkg_json = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(str))))
    for recipe_d in recipes:

        ## Get recipe info
        channel = recipe_d["ggd_channel"]
        species = recipe_d["species"]
        genome_build = recipe_d["genome_build"]
        name = recipe_d["name"]
        href = recipe_d["Package"]

        ## Add to dict
        pkg_json[channel][species][genome_build][name] = href
   
    ## Create a json file with recipe info in it 
    with open("build/html/recipes.json", "w") as j:
        j.write("recipe_data = ")
        json.dump(pkg_json, j)

    ## Update recipe.rst
    updated = renderer.render_to_file("source/recipes.rst", "recipes.rst_t", {})
    if updated:
        logger.info("Updated source/recipes.rst")


def setup(app):
    app.connect('builder-inited', generate_recipes)
    return {
        'version': "0.0.1",
        'parallel_read_safe': True,
        'parallel_write_safe': True
    }
