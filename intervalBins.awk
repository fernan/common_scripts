module load gawk/4.1.3
##to execute 
#cat inputfile | intervalBins.awk interval
#cat inputfile | intervalBins.awk 1000
##input looks like
#Chr01 genomicPosition
#Chr02 genomicPosition
#Scaffold1 genomicPosition
##output looks like
#Chr01 interval geneticElementsPerInterval

gawk 'BEGIN {  OFS="\t"; BINSIZE="'$1'"; } 
{ A=sprintf("%d", $2/BINSIZE);
  BIN[$1][A]++; } 
END { for (X in BIN) { 
	for (Y in BIN[X]) {print X, Y, BIN[X][Y] }} }'
