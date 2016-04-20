from __future__ import print_function
import sys
import os
import os.path as op
import re
import subprocess as sp
import tarfile
from fnmatch import fnmatch

import yaml


def conda_root():
    return sp.check_output(['conda', 'info', '--root']).strip()


def list_files(dir):
    r = []
    subdirs = [x[0] for x in os.walk(dir)]
    for subdir in subdirs:
        files = os.walk(subdir).next()[2]
        if (len(files) > 0):
            for file in files:
                r.append(op.join(subdir, file))
    return r


def main(fbz2):

    info = None
    with tarfile.open(fbz2, mode="r|bz2") as tf:
        for info in tf:
            if info.name == "info/recipe/meta.yaml":
                break
        else:
            raise KeyError

        recipe = tf.extractfile(info)
        recipe = yaml.load(recipe.read().decode())

    try:
        species, build = check_yaml(recipe)
    except:
        print("YAML ERROR", file=sys.stderr)
        raise

    install_path = op.join(conda_root(), "share", "ggd", species, build)
    check_files(install_path, species, build, recipe['package']['name'],
                recipe['extra'].get('extra-files', []))
    print("OK")

def check_files(install_path, species, build, recipe_name, extra_files):
    P = "{species}/{build}:{recipe_name}".format(**locals())

    files = list_files(install_path)
    tbis = [x for x in files if x.endswith(".tbi")]
    nons = [x for x in files if not x.endswith(".tbi")]

    tbxs = [x[:-4] for x in tbis if x[:-4] in nons]

    nons = [x for x in nons if not x in tbxs]
    # check for fais?
    fais = [x for x in nons if x.endswith(".fai")]
    nons = [x for x in nons if not x in fais]
    fais = map(op.basename, fais)

    # ignore gzi
    nons = [n for n in nons if not n.endswith('.gzi')]

    gf = op.join("genomes", "{build}", "{build}.genome").format(build=build)

    for tbx in tbxs:
        print("> checking %s" % tbx)
        try:
            sp.check_call(['check-sort-order', '--genome', gf, tbx], stderr=sys.stderr)
        except sp.CalledProcessError as e:
            sys.stderr.write("ERROR: in: %s(%s) with genome sort order compared to that specified in genome file\n" % (P, tbx))
            sys.exit(e.returncode)

    missing = []
    not_tabixed = []
    not_faidxed = []
    for n in nons:
        print("> checking %s" % n)
        if n.endswith((".bed", ".bed.gz", ".vcf", ".vcf.gz", ".gff",
                       ".gff.gz", ".gtf", ".gtf.gz", ".gff3", ".gff3.gz")):

            not_tabixed.append("ERROR: with: %s(%s) must be sorted, bgzipped AND tabixed.\n" % (P, n))
        elif n.endswith((".fasta", ".fa", ".fasta.gz", ".fa.gz")):
            if not op.basename(n + ".fai") in fais and not (re.sub("(.+).fa(?:sta)?$",
                                                       "\\1",
                                                       op.basename(n)) + ".fai") in fais:
                not_faidxed.append("ERROR: with: %s(%s) fasta files must have an associated fai.\n" % (P, n))

        elif op.basename(n) not in extra_files and not any(fnmatch(op.basename(n), e) for e in extra_files):
                missing.append("ERROR: %s(%s) uknown file and not in the extra/extra-files section of the yaml\n" % (P, n))

    if missing or not_tabixed or not_faidxed:
        print("\n".join(missing + not_tabixed + not_faidxed), file=sys.stderr)
        sys.exit(2)


def check_yaml(recipe):

    assert 'extra' in recipe, ("must specify 'extra:' section with genome-build and species")
    assert 'genome-build' in recipe['extra'], ("must specify 'extra:' section with species")
    assert 'species' in recipe['extra'], ("must specify 'extra:' section with species")
    assert 'keywords' in recipe['extra'] and \
        isinstance(recipe['extra']['keywords'], list), ("must specify 'extra:' section with keywords")
    assert 'about' in recipe and 'summary' in recipe['about'], ("must specify an 'about/summary' section")

    species, build = recipe['extra']['species'], recipe['extra']['genome-build']

    assert op.exists(op.join("genomes", build)), ("build directory: %s does not exist in ggd-recipes. new genomes must be added to the repo." % build)
    return species, build

if __name__ == "__main__":
    main(sys.argv[1])

