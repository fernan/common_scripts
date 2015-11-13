QLresultsPvaluePlot<-function(QLfit,Strname){
filename=Strname
results<-QL.results(QLfit,Plot=F)
designNum<-dim(results$P.values$QLSpline)[2]
designNames<-colnames(results$P.values$QLSpline)
 for (i in 1:designNum){
 print(i)
   if (min(results$P.values$QLSpline[,i])<1 && min(results$P.values$QLSpline[,i])!="NaN"){
   #need to add info to plot

     #results$P.values$QLSpline
     Rnames<-rownames(dataIn)
   #need to output this information to a file perhaps join the columns (do a cbind of identical outputs of qvalues or qvalue pvalue and then rowname it)
   
   #gives Qvalues  want to cbind to include pvalues
     #print(as.matrix(results$Q.values$QLSpline[which(results$Q.values$QLSpline[,i]<0.3),i]))
   #Gives original dataIn matrix
     if (min(results$Q.values$QLSpline[,i])<0.1 && min(results$Q.values$QLSpline[,i])!="NaN"){

       if (length(which(results$Q.values$QLSpline[,i]<0.1))>1){
       outData<-cbind(as.matrix(dataIn[which(results$Q.values$QLSpline[,i]<0.1),]),as.matrix(results$P.values$QLSpline[which(results$Q.values$QLSpline[,i]<0.1),i]),as.matrix(results$Q.values$QLSpline[which(results$Q.values$QLSpline[,i]<0.1),i]),(sign(rowSums(dataIn.norm[which(results$Q.values$QLSpline[,i]<0.1),which(trt==1)])-rowSums(dataIn.norm[which(results$Q.values$QLSpline[,i]<0.1),which(trt==2)])))*rowSums(dataIn.norm[which(results$Q.values$QLSpline[,i]<0.1),which(trt==1)])/rowSums(dataIn.norm[which(results$Q.values$QLSpline[,i]<0.1),which(trt==2)]))
       colnames(outData)<-c(colnames(dataIn),"Pvalues","Qvalues","fold_change")
       write.table(outData,file=paste(filename,".FulldesignVS.",i,".txt",sep=""))
       }
       if (length(which(results$Q.values$QLSpline[,i]<0.1))==1){
outData<-cbind(matrix(dataIn[which(results$Q.values$QLSpline[,i]<0.1),],1,dim(dataIn)[2]),as.matrix(results$P.values$QLSpline[which(results$Q.values$QLSpline[,i]<0.1),i]),as.matrix(results$Q.values$QLSpline[which(results$Q.values$QLSpline[,i]<0.1),i]),(sign(sum(dataIn.norm[which(results$Q.values$QLSpline[,i]<0.1),which(trt==1)])-sum(dataIn.norm[which(results$Q.values$QLSpline[,i]<0.1),which(trt==2)])))*sum(dataIn.norm[which(results$Q.values$QLSpline[,i]<0.1),which(trt==1)])/sum(dataIn.norm[which(results$Q.values$QLSpline[,i]<0.1),which(trt==2)]))
       colnames(outData)<-c(colnames(dataIn),"Pvalues","Qvalues","fold_change")
       write.table(outData,file=paste(filename,".FullvsDesignVS.",i,".txt",sep=""))
       }
}
     
     pdf(file=paste(filename,".",i,".pdf",sep=""),width=5,height=5)
     a<-hist(results$P.values$QLSpline[,i],breaks=seq(0,1,.01),main=paste(Strname,designNames[i]),cex.main=.5)
     b<-a$counts[1]*.75
     bb<-a$counts[1]*.65
     bbb<-a$counts[1]*.55
     text(.5,b,paste("Number of genes qvalue below 0.5 = ",as.character( dim(as.matrix(dataIn[which(results$Q.values$QLSpline[,i]<0.5),i]))[1])),cex=.8)
     text(.5,bb,paste("Number of genes qvalue below 0.3 = ",as.character( dim(as.matrix(dataIn[which(results$Q.values$QLSpline[,i]<0.3),i]))[1])),cex=.8)
     text(.5,bbb,paste("Number of genes qvalue below 0.1 = ",as.character( dim(as.matrix(dataIn[which(results$Q.values$QLSpline[,i]<0.1),i]))[1])),cex=.8)
     dev.off()
     
   }
 }
}

