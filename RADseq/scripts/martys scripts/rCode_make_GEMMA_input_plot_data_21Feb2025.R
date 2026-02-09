# make ped files that includes phenotype values for Methow RAD GWAS in GEMMA
setwd("~/Documents/Methow_steelhead/RAD/filter_1-2025")
ped <- read.table("Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds_corrNames.ped",header=FALSE)
map <- read.table("Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds_corrNames.map",header=FALSE)

# get the phenotypes
phenoIn <- read.table("phenosOut2", header=TRUE)
growthOut <- phenoIn[match(ped[,1],phenoIn$scanID),c(1,ncol(phenoIn))]
smoltOut  <- phenoIn[match(ped[,1],phenoIn$scanID),c(1,ncol(phenoIn)-1)]

# this needs to equal 0
sum(growthOut[,1] != ped[,1])


# make PLINK files for growth phenotype
ped_growth <- ped
ped_growth[,6] <- growthOut[,2]

write.table(ped_growth,file="growth.ped",row.names=FALSE,col.names=FALSE,quote=FALSE)
write.table(map,file="growth.map",row.names=FALSE,col.names=FALSE,quote=FALSE)


# make PLINK files for smoltification phenotype
ped_smolt <- ped
ped_smolt[,6] <- smoltOut[,2]

write.table(ped_smolt,file="smolt.ped",row.names=FALSE,col.names=FALSE,quote=FALSE)
write.table(map,file="smolt.map",row.names=FALSE,col.names=FALSE,quote=FALSE)


# make a covariate file
covar <- NULL
covar <- cbind(covar,rep(1,nrow(ped)))
covar <- cbind(covar,phenoIn$Treatment)
write.table(covar,file="covariates_gemma",quote=FALSE,row.names=FALSE,col.names=FALSE)

library(scales)
# plot growth by treatment
labs <- c("EC","EW","LC","LW")
plot(c(0.7,4.3),c(0,1.2),type="n",xlab="Treatment",ylab="Growth",axes=FALSE)
axis(side=1,at=1:4,labels=labs)
axis(side=2,at=seq(0,1.2,0.2))

for(i in 1:length(labs)){
  thisDat <- phenoIn$growth[which(phenoIn$Treatment == labs[i])]
  points(x=i+runif(n=length(thisDat),min=-0.05,max=0.05),y=thisDat,pch=16,col=alpha("blue",alpha=0.2))
  

  # calculate and plot a bootstrap CI for sample mean
  noMissDat <- thisDat[which(is.na(thisDat) == FALSE)]
  ci <- quantile(noMissDat,probs=c(0.025,0.975))
  points(x=i,y=mean(noMissDat),cex=1.7,pch=16,col="black")
  arrows(x0=i,x1=i,y0=mean(noMissDat),y1=ci[2],length=0.05,angle=90,lwd=1.5)
  arrows(x0=i,x1=i,y0=mean(noMissDat),y1=ci[1],length=0.05,angle=90,lwd=1.5)
}

treats <- c("EC","EW","LC","LW")
cols <- c("blue","lightgreen","orange","pink")
colVec <- rep(NA,nrow(phenoIn))
for(i in 1:4){
  colVec[which(phenoIn$Treatment == treats[i])] <- cols[i]
}

phenoPlot <- cbind(phenoIn,colVec)
plot(c(0,9),c(0,1.1),type="n",ylab="Growth",xlab="Tank",axes=FALSE)

axis(side=2,at=seq(0,1.1,0.1))
tanks <- NULL
xIter <- 0
for(i in 1:length(treats)){
  thisDat <- phenoPlot[which(phenoPlot$Treatment == treats[i]),]
  theseTanks <- unique(thisDat$Tank)
  tanks <- c(tanks, theseTanks)

  for(j in 1:length(theseTanks)){
    xIter <- xIter + 1
    tankDat <- thisDat$growth[which(thisDat$Tank == theseTanks[j])]
    theseCols <- thisDat$colVec[which(thisDat$Tank == theseTanks[j])]
    points(x=xIter+runif(n=length(tankDat),min=-0.1,max=0.1),y=tankDat,pch=16,col=alpha(theseCols,alpha=0.5))
    
    # calculate and plot a bootstrap CI for sample mean
    noMissDat <- tankDat[which(is.na(tankDat) == FALSE)]
    ci <- quantile(noMissDat,probs=c(0.025,0.975))
    points(x=xIter,y=mean(noMissDat),cex=1.7,pch=16,col="black")
    arrows(x0=xIter,x1=xIter,y0=mean(noMissDat),y1=ci[2],length=0.05,angle=90,lwd=1.5)
    arrows(x0=xIter,x1=xIter,y0=mean(noMissDat),y1=ci[1],length=0.05,angle=90,lwd=1.5)
  }
}

axis(side=1,at=1:8,labels=tanks)
legend(x=0.3,y=0.9,xjust=FALSE,yjust=FALSE,legend = treats,col=cols,pch=16,cex=1,bty="n")