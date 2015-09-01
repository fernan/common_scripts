module load gawk/4.1.3
gawk 'BEGIN {  OFS="\t"; BINSIZE="'$1'"; } 
{ A=sprintf("%d", $2/BINSIZE);
  BIN[$1][A]++; } 
END { for (X in BIN) { 
	for (Y in BIN[X]) {print X, Y, BIN[X][Y] }} }'
