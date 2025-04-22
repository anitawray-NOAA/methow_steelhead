#make an LD matrix for omy5 snps in Methow RADSeq data
setwd("~/Documents/Methow_steelhead/RAD/filter_1-2025")
library(SNPRelate)
dat <- snpgdsOpen("ld_gds")
ldMatrix <- snpgdsLDMat(gdsobj=dat,slide=-1,method= "corr")
ld <- abs(ldMatrix[[3]])

snpInfo <- read.table("ld_snp_info",header=TRUE)

#prune number of loci
prunNum <- 1000

keepLoci <- sort(sample(1:(nrow(snpInfo)-1),prunNum-1,replace=FALSE))
keepLoci <- c(keepLoci,nrow(snpInfo))
ld2 <- ld[,keepLoci]
ld2 <- ld2[keepLoci,]
snpInfo2 <- snpInfo[keepLoci,]

# save results

write.table(ld2,file="LD_omy5_1Kloci",row.names=FALSE,col.names=FALSE,quote=FALSE)
write.table(sn,file="LD_omy5_1Kloc_snpInfo",row.names=FALSE,col.names=FALSE,quote=FALSE)

# plot results


numLoci <- nrow(snpInfo2)
plot(c(1,numLoci),c(0,numLoci),ylim=c(-0.19*prunNum,prunNum),type="n",axes=FALSE,ylab="",xlab="Position (Mb)")

# make a color ramp 
palette <- colorRampPalette(rev(c("blue", "orange", "red")), space = "rgb")
ramp <- rev(palette(10))
for(i in 1:(nrow(ld2)-1) ){
  scores <- ceiling(ld2[i,(i+1):ncol(ld2)]*10)
  cols <- ramp[scores]
  xs <- seq(from=i+0.5,to = (length(scores)-1)*0.5 + i + 0.5,by=0.5)
  ys <- (1:length((i+1):numLoci))
  points(x = xs,y = ys,pch=18,col=cols,cex=0.5)
} 

chromPos <- -0.15*prunNum

lines(c(0,nrow(ld2)),y=c(chromPos,chromPos),lwd=1)
relPos <- (snpInfo2[,3] - min(snpInfo2[,3]))/max(snpInfo2[,3] - min(snpInfo2[,3]))
sampLoci <- c(seq(1,nrow(snpInfo2),5),nrow(snpInfo2))
plotPos <- snpInfo2[sampLoci,]
plotPos[,3] <- plotPos[,3]/1000000
for(i in 1:nrow(plotPos)){
  lines(x=c(sampLoci[i],relPos[sampLoci[i]]*prunNum),y=c(0,chromPos))
}
par(xpd=TRUE)
#text(x=seq(0,prunNum,100),y=c(-0.2*prunNum,-0.2*prunNum),labels=seq(0,snpInfo2[nrow(snpInfo2),3]/1000000,10))
xPos <- c(0,seq(10,90,10),round(snpInfo2[nrow(snpInfo2),3]/1000000,digits=1))
plotXPos <- 0 + (xPos/max(xPos))*prunNum
text(plotXPos,y=rep(-0.19*prunNum,length(plotXPos)),labels=xPos)

