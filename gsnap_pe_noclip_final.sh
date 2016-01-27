#!/bin/bash
# this is optimized to run on 32 procs: spliting input to 16 peices, 2 procs per peice

## MODULES
module load LAS/parallel/20150922
module load Serdor
module load gmap-gsnap/2015-09-29

#create different amount of wait times to ensure we don't have multiple rsyncs
sleep $(( ( RANDOM % 30 )  + 1 ))

if [ ! -d "$TMPDIR/GMAPDBTMP" ]; then
echo "copying over GSNAPDB"
mkdir $TMPDIR/GMAPDBTMP
#wait for up 2 four minutes to spread out the rsync jobs.
sleep $(( ( RANDOM % 240 )  + 1 ))
rsync -avz $GMAPDB/ $TMPDIR/GMAPDBTMP/
fi
  
export GMAPDBTMP=$TMPDIR/GMAPDBTMP
## PATHS
DB_NAME=$GNAME

FILE1="$1"
FILE2=$(echo "$1" |sed 's/_R1_/_R2_/g')

OUTFILE=$(basename ${FILE1%%.*})

## COMMAND
# important options to consider
#==============================
# if using RNA-seq, use: --novelsplicing=1
#
# if mate pairs use: --orientation=RF
# and specify the insert size using −−pairlength=2000 (for 2kb insert)
# and −−pairmax=5000 (for max insert size)
#
# for allowing soft-clipping of alignments, exlucde all 3 options below:
# --terminal-threshold=100
# --indel-penalty=1
# --trim-mismatch-score=0
#
# if fastq is gzipped use:
# --gunzip
#--novelsplicing=1 \
#--gunzip \
mkdir OUTPUT_${OUTFILE}
parallel --env _ --jobs 1 \
  "gsnap \
--dir=$GMAPDBTMP \
--db=${DB_NAME} \
--part={}/4 \
--batch=4 \
--nthreads=15 \
--indel-penalty=1 \
--trim-mismatch-score=0 \
--expand-offsets=1 \
--max-mismatches=5.0 \
--input-buffer-size=1000000 \
--output-buffer-size=1000000 \
--format=sam \
--split-output=OUTPUT_${OUTFILE}/${DB_NAME}_AP_${OUTFILE}.{} \
--failed-input=OUTPUT_${OUTFILE}/${DB_NAME}_AP_${OUTFILE}.not_mapped.{} \
${FILE1} \
${FILE2} " \
::: {0..0}
