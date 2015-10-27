#########################################################	
#plotting function
#this function will generate intervals of significant clustering of SNPs on soybean chromosomes scaled to the longest chromosome.

ChromosomePlot<-function(chromosomelength,intervalstart,intervalend,intervalheight,maxNumGenesInCluster,maxchromosomelength,binScales,currentBinScale,SNPcoords){
		
		#The axis labels require resizing depending on the width of the plot  
		#the following is an estimate of the resizing required
			if (maxchromosomelength<750000){
				XcexVar<-1
			}
			if (maxchromosomelength>750000 & maxchromosomelength<12000000){
				XcexVar<-(-0.3125)*log(maxchromosomelength/1000000)+0.91
			}
			if (maxchromosomelength>12000000){
				XcexVar<-.1
			}

		
		#I make use of the rect function that has input as (xleft, ybottom, xright, ytop)
		#keep in mind everything is scaled to Gm18, the largest chromosome
		xleft=(1/maxchromosomelength)*intervalstart
		ybottom=0
		width=(intervalend-intervalstart)/maxchromosomelength
		averagepos<-(intervalend+intervalstart)/(2*maxchromosomelength)
		
		average<-(intervalend+intervalstart)/(2)
		xright=xleft+width
		ytop=intervalheight/maxNumGenesInCluster
		rect(0,0,chromosomelength/maxchromosomelength,-0.04)																			#this draws the chromosome on the bottom
		rect(SNPcoords/maxchromosomelength,0,SNPcoords/maxchromosomelength ,-0.04,lwd=.1)												#this draws the location of each SNP
		rect(xleft,ybottom,xright,ytop,border="black",col=rainbow(length(binscales))[which(binscales==currentBinScale)])				#Significant Intervals of SNPs
		text(chromosomelength/(2*maxchromosomelength),-.02,labels=paste("chromosome",i),cex=.5)											#chromosome name
		text(SNPcoords/maxchromosomelength-2000/maxchromosomelength,-.02,labels=rownames(SNPcoords),cex=XcexVar,srt=90)					#location of each Interval
		axis(1,tick=T,at=intervalstart/maxchromosomelength,labels=intervalstart,cex.axis=XcexVar,las = 2,lwd=.5)						#axis 1
		axis(2,tick=T,at=seq(0,1,1/maxNumGenesInCluster),labels=0:maxNumGenesInCluster,cex.axis=.8)										#axis 2
		ablineMulti<-function(i){abline(i,0,col="darkgrey",lwd=.1)}																		#Creates a grid at 2 SNP intervals
		sapply(seq(0,1,2/maxNumGenesInCluster),ablineMulti)																				#sapply to create the grid	
		}

#########################################################	
#ElementList could be a list of snps or genes must be a matrix with at least 2 columns
#scaffoldIDs are the IDs you wish to map the elements onto.
#scaffoldID<-scaffoldIDs[i]
identifyElementsonScaffold<-function(ElementList,scaffoldID){
		scaffoldID<-paste(scaffoldID,"_",sep="")
		ElementListRN<-rownames(ElementList)
		elements<-ElementList[grep(scaffoldID,ElementListRN),]
		return(elements)
}
		#elementListNames<-rownames(ElementList)

#########################################################	
#This function will give the index number in a matrix given the rowname.	
IndexFromelementCall<-function(inputmatrix,rowname){	
	match(rowname,rownames(inputmatrix),nomatch=0)
}
#########################################################
	
#this section will take the same number of genes and simulate how the genes will fall into the bins based on the 1000(or numofsims) random collections of genes
	
	#positions2sample in the case of SNPs in RNA-seq data are all the gene calls in the genome and their average positions
	#in the case of genomic dna it is a matrix with every possible position from start to end of each chromosome
	
	#numofsims = simulations to perform 1000
	#Position2sample = sampleFromCoords  ie sample from these coordinates  (genes or other elements throughout genome all scaffolds)
	#elements = elements of interest specific to the scaffoldID
	#scaffoldID = i since i in scaffoldIDs will be a list of the scaffolds
	
	#positionstoSampleonScaffold = 
	#positionSample = rownames sampled from elements of interest
	
	simulateData<-function(numofsims,Positions2sample,elements,scaffoldID,useRandomLocation){		
			#matrix for storing simulations
			if(useRandomLocation==0){
				positionstoSampleonScaffold<-identifyElementsonScaffold(Positions2sample,scaffoldID) #specific to the scaffold of interest
				positionSample<-sample(positionstoSampleonScaffold,dim(elements)[1]*numofsims,replace=T) #sample created based on number of SNPs or elements of interest
				positionSampleNames<-rownames(positionSample)
				positionSample<-matrix(positionSample,ncol=dim(elements)[1])
				}else{
				positionSample<-sample(Positions2sample,dim(elements)[1]*numofsims,replace=T) #sample created based on number of SNPs or elements of interest
				positionSample<-matrix(positionSample,ncol=dim(elements)[1])
				}
				
# 					PositionindexCoords<-function(z){IndexFromelementCall(Positions2sample,positionSampleNames[z])} #This function will give the index number in a matrix given the rowname.	
# 					sampleIndex<-sapply(1:length(positionSample),PositionindexCoords)
# 					sampleIndex<-matrix(sampleIndex,ncol=dim(elements)[1])
					#return(list(positionSample=positionSample,sampleIndex=sampleIndex))
				return(positionSample)
				
	}
	
#insert code for genome wide sampling


	#provide an if statement in the script
	
	#########################################################
read.sample<-function(filename){
	coordinates<-read.table(filename)
	coordinatesAve<-matrix(round((coordinates[,3]+coordinates[,4])/2),ncol=1)
	rownames(coordinatesAve)<-coordinates[,1]
	return(coordinatesAve)
	}
#########################################################	
#Boostrap function for clustering on a chromosome

#generation of the bin sizes across the chromosome
clusterByBoostrap<-function(chromosomelength,binsize,elements,numofsims,bootData){
	#print(SNPCoordinates)
	numBins<-floor(chromosomelength/binsize)
	
#this section will calcluate how many of of the SNPs we are interested in fall into each bin
	breaks1<-seq(0,chromosomelength,binsize) 
	chromBinsFind<-findInterval(elements,breaks1, rightmost.closed=T)

  	chromBins<-hist(chromBinsFind,breaks=seq(0,length(breaks1),1),plot=F)$counts
	#print(chromBins)	
	
	
	chromBinsSample<-matrix(0,numofsims,length(breaks1))							#simulated data storage matrix
			for (j in 1:numofsims){	
			#generation of the bin sizes across the chromosome for the simulated data
				breaks1<-seq(0,chromosomelength,binsize) 
				chromBinsSam<-findInterval(bootData[j,],breaks1, rightmost.closed=T)
				chromBinsSample[j,]<-hist(chromBinsSam,breaks=seq(0,length(breaks1),1),plot=F)$counts	
			}
			#Average and standard deviation of the simulated data
			chrombinsAve<-colMeans(chromBinsSample)
			
			
			chrombinsSD<-sd(chromBinsSample)
			
	#print(chrombinsAve)
	#print(chrombinsSD)
	
			
#this section is the determination of the bins that are significant
			
			over3stdev<-which((chromBins-(chrombinsAve+3*chrombinsSD))>0)
			over3stdevBy<-(chromBins-(chrombinsAve+3*chrombinsSD))[over3stdev]
			over3stdevZscore<-round(((chromBins-(chrombinsAve))[over3stdev])/chrombinsSD[over3stdev],2)
			
			#this if statement is required in case no intervals are found to be significant

			if (length(over3stdev)==0){
				print("No significant intervals found")
				return(0)		
			}else{
			significantIntervals<-matrix(c(breaks1[over3stdev],breaks1[over3stdev]+binsize),length(over3stdev),2)
			}
			
			   #append number of genes in the bin and the zscore to significantIntervals
  	significantIntervals<-matrix(cbind(significantIntervals,chromBins[over3stdev],over3stdevZscore),ncol=4)
  	significantIntervals<-matrix(significantIntervals[sort(significantIntervals[,1],index.return=T)$ix,],ncol=4)

   	significantIntervals<-matrix(significantIntervals[which(significantIntervals[,3]>5),],ncol=4)
	return(significantIntervals)

}

