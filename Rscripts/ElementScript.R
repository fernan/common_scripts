#This script is used to cluster genomic elements onto scaffolds.  Requires Elementsource.R 
#Created on10/27/11 by Andrew Severin andrewseverin@gmail.com 
#Iowa State University

#note for McGrail data
#create scaffoldLengths.txt file
#create Elements of Interest file from location of read mapping  
#install gplots on lightning3
#run

#required input files

#ScaffoldLengths.txt file
#          na         ch start      end na.1 na.2 na.3                note
# Gm01  . chromosome     1 55915595    .    .    .   Name=Gm01;Alias=D1a
# Gm02  . chromosome     1 51656713    .    .    .   Name=Gm02;Alias=D1b
# Gm03  . chromosome     1 47781076    .    .    .   Name=Gm03;Alias=N

#ElementsofInterest file so what you are clustering.

#optional input file 	useRandomLocation<-0
#sampleFromCoords file if you want to random sample from specific locations in the genome  (ie genes since SNPs were obtained from RNA-Seq)

#required libraries
	library(gplots)
	source('Elementsource.R')
	
	#starting parameters 
	useRandomLocation<-1 									#random location from any position on the scaffold 0 for specified positions.
	if(useRandomLocation==0){
	sampleFromCoords<-read.sample('geneCoords.txt') #set this file as input scaffold_geneID location location
	}
	readlength<-75
	dir<-"./"  
	numofsims<-1000  #with sims less than 1000 you can end up with infinite zscores  fyi
	ElementsofInterest<-read.table('Drerio.unpaired.uniq.ptol.otherChrom.locs') 		#list with Elements of interest
    chrom<-read.table('Drchrom.txt') #gff format file that contains the following, really fields 1 4 and 5 need to be in the right columns and need the header

    
    

#this section is optional if you would like to have multiple bin sizes uncomment	
	#StartingBinsize<-6000000									#important the the vector in this forloop results in binsizes that include the binsizes before it
	#binscales<-c(1,2,6,12,60,120)								#for binsize 6M 3M 1M 500K 100K 50k
#For multiple bin sizes comment out this block of code
	StartingBinsize<-1000									#Here I chose just one binsize
	binscales<-c(1)	
	
	
#variables calculated from the input parameters
	
	chromosomelengthAll<-chrom[,3]
	maxchromosomelength<-max(chrom[,3])
	significantIntervalsOrig<-0
	scaffoldIDs<-rownames(chrom)
#	scaffoldIDs<-"Dr5"



#this for loop will cycle through each chromosomes.
	for (i in scaffoldIDs){
		dir.create(paste("./",i,sep=""))						#create directory to export outfiles
		chromosomelength<-chrom[i,3]
	
	maxNumElementsInCluster<-0										#initiate a variable that will be needed later for plotting
	
	elements<-identifyElementsonScaffold(ElementsofInterest,i)
	#SNPs<-identifySNPSOnChromosomeForSoybean(SNPsofInterest,i)	#this function will identify the SNPs on each chromosome as it goes through the loop
	#print(dim(elements[1]))
	if (dim(elements)[1]<3){										#No need to look at chromosomes that do not have at least 3 SNPs
	print(elements)
	next()
	}

if(useRandomLocation==1){  #I have set it up so that it samples from the midpoints of equally spaces reads along the chromosome.
start<-readlength/2
end<-chromosomelength-start
sampleFromCoords=seq(start,end,readlength)
#sampleFromCoords=1:chromosomelength
#sampleFromCoords=elements[,1]
}
#print(useRandomLocation)

	bootData<-simulateData(numofsims,sampleFromCoords,elements,i,useRandomLocation)			#generate the simulated data  (See SNPsource for code)

#print(bootData)
#binSize (for loop) will cycle through the binsizes determined above
	for (b in binscales){
		
		binsize<-StartingBinsize/b
		print(binsize)
		appendtofilename<-paste("_",binsize/binscales,sep="")						#this variable is used for the outputfiles to distinguish between bins
		elementcoords<-elements[,1]															#for retrieval of the coordinates of the SNPs of interest


#function to do bootstrap method
#sigint<-clusterByBoostrap(chromosomelengthAll[16],StartingBinsize,elements[,1],10,bootData)
		significantIntervals<-clusterByBoostrap(chromosomelength,binsize,elements[,1],numofsims,bootData)
		print(significantIntervals)
		
		if (b==binscales[1]){
		#open a pdf file
		pdf(file=paste(i,"chrom",i,"ALL",".pdf",sep=""),paper="special",height=7,width=100)
		plot(0:1, 0:1, type="n", axes=FALSE, ann=FALSE)
		}
#if there are no significant Intervals go to the next binsize in the loop
		
		if(length(significantIntervals)==0){
		print("no significant intervals")
			next
		}
#This block estimates the required Y dimension for plotting and works for most cases
			if (maxNumElementsInCluster==0){												
				maxNumElementsInCluster<-max(significantIntervals[,3])+1
			}
print(maxNumElementsInCluster)
			
#required input variables for the plotting function.  ChromosomePlot can be found in SNPsource.
			intervalstart<-significantIntervals[,1]
			intervalend<-significantIntervals[,2]
			intervalheight<-significantIntervals[,3]
			currentBinScale<-b
			ChromosomePlot(chromosomelength,intervalstart,intervalend,intervalheight,maxNumElementsInCluster,maxchromosomelength, binScales, currentBinScale,elements[,1])
			
			if(b==binscales[length(binscales)]){
			#now that the plotting is finished, close the pdf file
			dev.off()
			}
			
			#write to file gene lists with intervals that are significant
			colnames(significantIntervals)<-c('intervalstart','intervalend','numberInInterval','ZscoreaboveBootstrap')
			write.table(significantIntervals,file=paste(i,"/clusterTable",i,appendtofilename,".txt",sep=""),append=T,quote=F,col.names=T)

	}
	
	#this commands save the R sessions for each chromosome into each chromosome folder respectively.
	#save.image(file = paste(i,"/.RData",i,sep=""))

}
