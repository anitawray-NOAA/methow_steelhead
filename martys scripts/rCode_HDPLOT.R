# run Garrett McKinney's HDPlot on the Methow RADSeq data to identify paralogs
setwd("~/Documents/Methow_steelhead/RAD/filter_1-2025")
library(vcfR)
source("HDplot.R")
library(reshape2)
vcfInput<-read.vcfR("Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01.recode.vcf")
HDplotResults<-HDplot(vcfInput)
library(scales)


cols <- rep("blue",length(HDplotResults$D))
dups <- which(HDplotResults$D > 5 | HDplotResults$D < -5 | HDplotResults$H > 0.6 | HDplotResults$ratio > 0.65 | HDplotResults$ratio < 0.35)
cols[dups] <- "red"

par(mfrow=c(2,1))
plot(HDplotResults$H,HDplotResults$D,pch=16,col=alpha(cols,alpha=0.2),xlab="H",ylab="D")
plot(HDplotResults$H,HDplotResults$ratio,pch=16,col=alpha(cols,alpha=0.2),xlab="H",ylab="Read ratio")


removeLoci <- HDplotResults[dups,1:2]

write.table(removeLoci,file="remove_paralogs",quote=FALSE,row.names=FALSE,col.names=FALSE)
