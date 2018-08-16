#!/bin/bash
#gets counts of splicing junctions
# Your gff must have an intron feature for this to work correctly.
# usage: sh run_SpliceSites.sh <genome.fasta> <genome.gff> <desired prefix><yes/no - if introns are present or not>
module load samtools
module load emboss


GENOME="$1"
GFF="$2"
PREFIX="$3"
samtools faidx $GENOME

if [ $4 = no ]
then
awk '{if(feature =="exon" && $3=="exon") {print $0;feature="exon";after=$4-1;print $1"\t"$2"\tintron\t"before"\t"after"\t"$6"\t"$7"\t"$8"\t"$9; before=$5+1} else if($3=="exon") {print $0;before=$5+1;feature="exon"} else {print $0;feature="other"}}' $GFF >GFF1
GFF=GFF1
fi
awk '$3=="intron" && $7=="+" {print "samtools faidx '$GENOME' "$1":"$4"-"$4+1" >>donorplus &" }' $GFF >extract.donorplus.sh
awk '$3=="intron" && $7=="+" {print "samtools faidx '$GENOME' "$1":"$5-1"-"$5" >>acceptorplus &" }' $GFF >extract.acceptorplus.sh
awk '$3=="intron" && $7=="-" {print "samtools faidx '$GENOME' "$1":"$4"-"$4+1" >>acceptorminus &" }' $GFF >extract.acceptorminus.sh
awk '$3=="intron" && $7=="-" {print "samtools faidx '$GENOME' "$1":"$5-1"-"$5" >>donorminus &" }' $GFF  >extract.donorminus.sh

wait
cat extract.donorplus.sh extract.acceptorplus.sh extract.acceptorminus.sh extract.donorminus.sh |sed '0~15 s/$/\nwait/g' >all.extractions.sh
wait
sh all.extractions.sh &
wait


revseq -notag -sequence acceptorminus -outseq revseq.acceptorminus
revseq -notag -sequence donorminus -outseq revseq.donorminus
cat donorplus revseq.donorminus >donors
cat acceptorplus revseq.acceptorminus >acceptors

echo "Acceptor"
grep -v ">" donors |grep -i -c "AG"|awk '{print "AG\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "AC"|awk '{print "AC\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "AT"|awk '{print "AT\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "AA"|awk '{print "AA\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "CA"|awk '{print "CA\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "CT"|awk '{print "CT\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "CC"|awk '{print "CC\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "CG"|awk '{print "CG\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "GC"|awk '{print "GC\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "GA"|awk '{print "GA\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "GT"|awk '{print "GT\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "GG"|awk '{print "GG\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "TT"|awk '{print "TT\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "TA"|awk '{print "TA\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "TC"|awk '{print "TC\t" $1}' >>$PREFIX\Splicetable &
grep -v ">" donors |grep -i -c "TG"|awk '{print "TG\t" $1}' >>$PREFIX\Splicetable 
wait
echo "Donor"
grep -v ">" acceptors |grep -i -c "AG" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "AC" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "AT" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "AA" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "CA" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "CT" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "CC" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "CG" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "GC" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "GA" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "GT" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "GG" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "TT" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "TA" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "TC" |awk '{print $1}' >>$PREFIX\Splicetable &
grep -v ">" acceptors |grep -i -c "TG" |awk '{print $1}' >>$PREFIX\Splicetable &
