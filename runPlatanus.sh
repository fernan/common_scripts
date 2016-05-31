#!/bin/bash

#platanus assemble \
#    -o plat_assembly \
#    -f read_250_[AB]_R[12].fq.trimmed \
#    -t 40 \
#    -m 500

#platanus scaffold \
#    -o plat_scaf \
#    -c plat_assembly_contig.fa \
#    -b  plat_assembly_contigBubble.fa \
#    -IP1 read_250_[AB]_R[12].fq.trimmed \
#    -OP2 matepair_R[12].fq.int_trimmed \
#    -n2 7000 \
#    -a2 8000 \
#    -d2 500 \
#    -t 40 \
#    -tmp $TMPDIR

platanus gap_close \
    -o plat_gapclose \
    -c plat_scaf_scaffold.fa \
    -IP1 matepair_R[12].fq.int_trimmed \
    -OP2 read_250_[AB]_R[12].fq.trimmed \
    -t 40 \
    -tmp $TMPDIR
  
