#!/usr/bin/python
Usage = """
Convert the FASTA sequences to static FASTQ format
Quality values are encoded as I for 40
needs input file and ouputfile names
Usage:
  fasta2fastq.py inputfile.fasta output.fastq

Arun Seetharam
arnstrm@iastate.edu
fasta2fastq.py -version 1.0
11/04/2015
"""
from Bio.SeqIO.FastaIO import SimpleFastaParser
import sys
if len(sys.argv)<3:
    print Usage
else:
   cmdargs = str(sys.argv)
   with open(str(sys.argv[1]) as in_handle:
      with open(str(sys.argv[2], "w") as out_handle:
         for title, seq in SimpleFastaParser(in_handle):
            out_handle.write("@%s\n%s\n+\n%s\n" \
                             % (title, seq, "I" * len(seq)))
