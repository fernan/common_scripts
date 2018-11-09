#!/bin/bash
file=$1
# get taxaid
g=$(basename ${f%%.*} |cut -f 1 -d "_")
echo -e "qseqid\tsseqid\tqstart\tqend\tsstart\tsend\tevalue\tscore\tstaxid" >  ${g}.tab
awk -v x=${g} 'BEGIN{OFS=FS="\t"}{print $1,$2,$7,$8,$9, $10, $11, $13, x}' $f  >>  ${g}.tab; done

