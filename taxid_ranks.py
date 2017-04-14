#!/usr/bin/python

Usage = """
Print taxid's lineage and ranks
by default prints to the stdout
Usage:
  taxid_ranks.py taxid > ouput.txt

Arun Seetharam
arnstrm@iastate.edu
taxid_ranks.py -version 1.0
04/13/2017
"""
from ete3 import NCBITaxa
import sys
ncbi = NCBITaxa()
if len(sys.argv)<2:
    print Usage
else:
    cmdargs = str(sys.argv)
    lineage = ncbi.get_lineage((sys.argv[1]))
    names = ncbi.get_taxid_translator(lineage)
    for taxid in lineage:
        print [ncbi.get_rank([taxid])], [names[taxid]]        
#    print [names[taxid] for taxid in lineage]
#    print [ncbi.get_rank([taxid]) for taxid in lineage]
#    print [ncbi.get_rank([name]) for name in names]
