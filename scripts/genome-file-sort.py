"""
helper for getting genome files set up.
we want lexical sort, but we want, e.g
chr2_xxx_random to be at the bottom of the file
here we just check for '_|.' and move those to the
bottom, otherwise, we do lexical sort.
"""

import sys

f = open(sys.argv[1])

header, normal, weird = [], [], []

for i, toks in enumerate(x.rstrip().split() for x in f if x.strip()):
    if i == 0 and not toks[1].isdigit():
        header.extend(toks)
        continue

    (weird if '_' in toks[0] or '.' in toks[0] else normal).append(tuple(toks))

print "\t".join(header)
print "\n".join("%s\t%s" % p for p in sorted(normal))
print "\n".join("%s\t%s" % p for p in sorted(weird))
