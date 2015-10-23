#!/bin/bash
############
# files needed
# 1. Genome File to which the sequences needs to aligned 
# 2. Output folder where all the temp and final results will be written
# 3. Draft assembly sequences
# enter them in that order for this scripts
# note that, for all the files you need to enter the full path
############

## define where the scripts are located (for add_contig_ID_to_seg.pl & merge_kmer_ranges.pl)
BINDIR="/data003/GIF/arnstrm/20150506_Hufford_maker/alignment/raw_files/kmer_align"
CPU=48 # number of parallel jobs  
KMER=23 # kmer size
TASSEL="/home/arnstrm/tassel/dist"
MEM=1500 # total system memory in GB
MPJ=$((${MEM} / ${CPU})) # calculate per job memory and round it to nearest integer

# modules required
module load parallel
module load java
module load tassel/5.2.16
module load perl
module load python

# easy names
TARGETDIR="$2"
REF="$1"
ASSEMBLY="$3"

# set-up for analyses
mkdir -p ${TARGETDIR} && cd ${TARGETDIR}
rm -f tasks_java tasks_sort tasks_merge

# generate job lists
for f in $(echo {A,T,G,C}{A,T,G,C}{A,T,G,C}); do
echo "java -Xmx${MPJ}g -cp ${TASSEL}/tassel5-active.jar net.maizegenetics.ed.t5.KmerAnalysisVB1 $KMER ${f} ${OUTNAME}_${f} ${REF} ${ASSEMBLY}" >> tasks_java
echo "sort -S ${MPJ}G -k 1,1 -k 2,2n ${OUTNAME}_${f}.seg >& ${OUTNAME}_${f}.seg.srt12" >> tasks_sort
echo "${BINDIR}/merge_kmer_ranges.pl ${OUTNAME}_${f}.seg.srt12 >& ${OUTNAME}_${f}.seg.srt12.mrg" >> tasks_merge
done

parallel --jobs ${CPU} --joblog java_tasks.log --workdir $PWD < tasks_java
parallel --jobs ${CPU} --joblog java_sort.log --workdir $PWD < tasks_sort
parallel --jobs ${CPU} --joblog java_merge.log --workdir $PWD < tasks_merge
cat ${OUTNAME}_???.seg.srt12.mrg | sort -S ${MEM} --parallel=${CPU} -k 1,1 -k 2,2n >& ${OUTNAME}.mrg.srt12
${BINDIR}/merge_kmer_ranges.pl ${OUTNAME}.mrg.srt12 >& ${OUTNAME}.mrg.srt12.mrg
${BINDIR}/add_contig_ID_to_seg.pl ${OUTNAME}.mrg.srt12.mrg ${REF} ${ASSEMBLY} | sort -k 8,8n -k 7,7r -k 5,5n - | cut -d " " -f 8 --complement > ${OUTNAME}.mrg.qsrt

