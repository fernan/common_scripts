#!/bin/bash
if [ $# -lt 3 ] ; then
        echo ""
        echo "usage: prepare_genome_modules.sh <genome_name> <build_number> <reference.fasta>"
        echo "build index for several aligners and writes a module file on condo"
        echo "does not overwrite any exisitng files"
        echo ""
        exit 0
fi

module load gmap
module load parallel
module load bowtie2
module load bwa
module load gatk
module laod bedtools

NAME="$1"
BUILD="$2"
REF="$3"
GSEQ="/data003/GIF/genomes/sequences"
GMOD="/data003/GIF/genomes/modules"
#intervals set to 100kb
WINDOW=100000

mkdir -p ${GSEQ}/${NAME}/${BUILD}
mkdir -p ${GMOD}/${NAME}
touch ${GSEQ}/${NAME}/${BUILD}

# build index for GSNAP, Bowtie2, BWA and SAMTOOLS
parallel <<FIL
gmap_build -d ${NAME}_${BUILD} -D ${GSEQ}/${NAME}/${BUILD} ${REF}
bowtie2-build ${REF} ${GSEQ}/${NAME}/${BUILD}/${NAME}_${BUILD}
samtools faidx ${REF}
bwa index -p ${NAME}_${BUILD} -a bwtsw ${REF}
java -Xmx100G -jar /data003/GIF/software/packages/picard_tools/1.130/picard.jar CreateSequenceDictionary \
  REFERENCE=${REF} \
  OUTPUT=${NAME}_${BUILD}.dict
FIL
# cleanup
mv ${REF}.fai ${GSEQ}/${NAME}/${BUILD}/${NAME}_${BUILD}.fai
mv ${NAME}_${BUILD}* ${GSEQ}/${NAME}/${BUILD}/
mv ${NAME}_${BUILD}.dict ${GSEQ}/${NAME}/${BUILD}/

# build intervals and cleanup
fasta_length.py ${REF} > ${GSEQ}/${NAME}/${BUILD}/${NAME}_${BUILD}_length.txt
bedtools makewindows -w ${WINDOW} -g  ${GSEQ}/${NAME}/${BUILD}/${NAME}_${BUILD}_length.txt >  ${GSEQ}/${NAME}/${BUILD}/${NAME}_${BUILD}_100kb_coords.bed
java -Xmx100G -jar $PICARD/picard.jar BedToIntervalList \
  INPUT=${GSEQ}/${NAME}/${BUILD}/${NAME}_${BUILD}_100kb_coords.bed \
  SEQUENCE_DICTIONARY=${GSEQ}/${NAME}/${BUILD}/${NAME}_${BUILD}_100kb_coords.dict \
  OUTPUT=${GSEQ}/${NAME}/${BUILD}/${NAME}_${BUILD}_100kb_gatk_intervals.list

# write a module file

cat <<MODULEFILE > ${GSEQ}/${NAME}/${BUILD}
#%Module1.0#####################################################################
##
module-whatis   "${NAME}"
setenv        GENOME        ${GSEQ}/${NAME}/${BUILD}/${NAME}_${BUILD}
setenv        GMAPDB        ${GSEQ}/${NAME}/${BUILD}
setenv        GNAME         ${NAME}_${BUILD}
MODULEFILE
