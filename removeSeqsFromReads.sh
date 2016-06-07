###This script should remove a particular sequence from a read and retain the largest fragment of the read that remains.  
module load samtools
module load ncbi-blast
#FASTA FILE OF READS
READS=$1
#THE LENGTH OF YOUR READS
READLENGTH=$2
#THE SEQUENCES THAT YOU WANT REMOVED FROM YOUR READS
BLASTQUERY=$3

#index the reads containing spliced leaders
samtools faidx $READS
#make a blast database of these same reads
makeblastdb -in $READS -dbtype nucl -out $READS.blast.db
#blasting the spliced leaders against these sequences again to gain info on their position within the reads
blastn -db $READS.blast.db -query $BLASTQUERY -outfmt 6 -word_size 19 -out $READS.blast.out

#Each line below evaluates whether the longest fragment of the read is at the 5' or 3' and then extracts the larger fragment.
rm seqremoved.faidx.sh
awk '$10<$9 && $9<50 {print "samtools faidx  '$READS' " '\$2' ":" '\$9' "-" "100"}' $READS.blast.out >>seqremoved.faidx.sh
awk '$9<$10 && $10<50 {print "samtools faidx  '$READS' " '\$2' ":" '\$10' "-" "100"}'  $READS.blast.out >>seqremoved.faidx.sh
awk '$10<$9 && $10>50 {print "samtools faidx  '$READS' "  '\$2' ":" "1" "-" '\$10'}'  $READS.blast.out >>seqremoved.faidx.sh
awk '$9<$10 && $9>50 {print "samtools faidx  '$READS' "  '\$2' ":" "1" "-" '\$9'}'  $READS.blast.out >> seqremoved.faidx.sh
awk '$10<$9 && $9<50 {print "samtools faidx  '$READS' " '\$2' ":" '\$9' "-" "100"}'  $READS.blast.out >> seqremoved.faidx.sh
awk '$9<$10 && $10<50 {print "samtools faidx  '$READS' " '\$2' ":" '\$10' "-" "100"}'  $READS.blast.out >>seqremoved.faidx.sh
awk '$10<$9 && $10>50 {print "samtools faidx  '$READS' " '\$2' ":" "1" "-" '\$10'}'  $READS.blast.out >>seqremoved.faidx.sh
awk '$9<$10 && $9>50 {print "samtools faidx  '$READS' " '\$2' ":" "1" "-" '\$9'}'  $READS.blast.out >>seqremoved.faidx.sh



##readlength loop
if [ $READLENGTH -eq 50 ]
then	
	sed -i 's/50/25/g' seqremoved.faidx.sh
	sed -i 's/100/50/g' seqremoved.faidx.sh
        echo "Reads are 50bp"
elif [ $READLENGTH -eq 150 ]
then
	sed -i 's/50/75/g' seqremoved.faidx.sh
        sed -i 's/100/150/g' seqremoved.faidx.sh	
	echo "reads are 150bp"
else
	echo "assuming reads are 100bp"
fi

#sometimes there are duplicates although I do not understand how.  so remove them.
sort seqremoved.faidx.sh |uniq >uniq.seqremoved.faidx.sh

#run the samtools script that was just made to extract the largest fragment of the read that is not a spliced leader.
sh uniq.seqremoved.faidx.sh >seqremoved.reads.fasta

