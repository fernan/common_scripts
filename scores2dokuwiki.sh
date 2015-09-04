#!/bin/bash
 tr -d '\015' < $1 | \
 sed 's/_fastqc.zip//g' |\
 sed 's/,-1/|@red: -1/g' |\
 sed 's/,0/|@yellow: 0/g' |\
 sed 's/,0/|@yellow: 0/g' |\
 sed 's/,1/|@lightgreen: 1/g' |\
 sed 's/$/|/' |sed 's/^/^/' |\
 sed 1i'^Fastq file ^BST ^BSQ ^SQS ^BSC ^GCc ^BNC ^SLD ^SDL ^ORS ^ADP ^KMR ^'

cat <<EOF
<code>
Where:
BST : Basic_statistics, 
TSQ : Per_base_sequence_quality, 
SQS : Per_sequence_quality_scores, 
BSC : Per_base_sequence_content, 
GCc : Per_sequence_GC_content, 
BNC : Per_base_N_content, 
SLD : Sequence_Length_Distribution, 
SDL : Sequence_Duplication_Levels, 
ORS : Overrepresented_sequences, 
ADP : Adapter_Content, 
KMR : Kmer_Content 
</code>
EOF
