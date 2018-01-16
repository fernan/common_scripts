#!/bin/bash
# run it as:
# runLTRfinder.sh genome.fasta
#you still need to check  overlap with repeatmodeler tracks, and use bedtools merge to eliminate redundancy in any subsequent analyses.
if [ $# -lt 1 ] ; then
        echo "usage: runLTRfinder.sh <genome.fasta>"
        echo ""
        echo "Identifies LTRs and other features of LTR retrotrtansposons"

        echo ""
exit 0
fi


GENOME=$1
module purge
module load GIF/ltrfinder
/work/GIF/software/programs/ltrfinder/1.0.5//ltr_finder ${GENOME} -w 1 2 >ltrFinderTable



