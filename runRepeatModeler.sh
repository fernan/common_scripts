#!/bin/bash
# runs repeat masking for the genome after constructing custom repeat library
# uses repeat modeler for building custom db and RepeatMasking for masking
# run it as:
# runRepeatModeler.sh Genome.fasta
# based on Rick's guide https://intranet.gif.biotech.iastate.edu/doku.php/people:remkv6:genome738polished_repeatmodeler_--de_novo_repeat_identification

GENOME="$1"
module use /shared/software/GIF/modules/
module load parallel
module load repeatmasker/4.0.6
module load repeatmodeler/1.0.8

DATABASE="$(basename ${GENOME%.*}).DB"
BuildDatabase -name ${DATABASE} -engine ncbi ${GENOME}
RepeatModeler -database ${DATABASE}  -engine ncbi -pa 16
RepeatMasker -pa 16 -gff -lib consensi.fa.masked ${GENOME}

