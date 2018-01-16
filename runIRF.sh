#!/bin/bash
# run it as:
# runIRF.sh genome.fasta
#you still need to check  overlap with repeatmodeler tracks, and use bedtools merge to eliminate redundancy in any subsequent analyses.
if [ $# -lt 1 ] ; then
        echo "usage: runIRF.sh <genome.fasta>"
        echo ""
        echo "Identifies terminal inverted repeats in the genome"

        echo ""
exit 0
fi


GENOME=$1
module purge
module load perl
module load GIF/irf/307

irf ${GENOME}  2 3 5 80 10 40 500000 10000 -t7 20000 -ngs >IRF.out


