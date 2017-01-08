#!/bin/bash
module use /shared/software/GIF/modules
module load hisat2
module load braker/1.9
module load maker/2.31.8b
module load samtools
module load gmap-gsnap/20160404

pre=$(pwd)
CHR="CHRFILE"
BASE=$(basename $(dirname $(pwd)))"
TRANS="${CHR}.all.maker.transcripts.fasta"

# train snap
mkdir ${CHR}_SNAP
cd ${CHR}_SNAP
maker2zff ../${CHR}.all.gff
fathom genome.ann genome.dna -categorize 1000
fathom -export 1000 -plus uni.ann uni.dna
forge export.ann export.dna
hmm-assembler.pl ${CHR} . > ../${CHR}.snap.hmm
cd ${pre}


# train augustus
GENOME="${CHR}.fasta"
gmap_build -d ${CHR} -D ${pre} ${GENOME}
gmap -d ${CHR} -D ${pre} -t 16 -B 5 -A -f samse --input-buffer-size=1000000 --output-buffer-size=1000000 ${TRANS} > aligned_reads.sam
samtools view --threads 16 -b -o aligned_reads.bam aligned_reads.sam
samtools sort -m 6G -o aligned_reads_sorted.bam -T samsort_temp --threads 16 aligned_reads.bam
braker.pl --cores=16 --overwrite --species=${CHR}.${BASE} --genome=${GENOME} --bam=aligned_reads_sorted.bam --gff3
