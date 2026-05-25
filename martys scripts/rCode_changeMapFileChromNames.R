# change chromosome names in map file for use in KING kinship estimation
map <- read.table("Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly.map",header=FALSE)
library(reshape2)
chromMat <- colsplit(map[,2],":",c("chrom","pos"))
chroms <- unique(chromMat[,1])

newChromMat <- NULL
for(i in 1:length(chroms)){
  thisIn <- chromMat[which(chromMat[,1] == chroms[i]),]
  thisOut <- NULL
  thisOut <- cbind(thisOut,rep(i,nrow(thisIn)))
  thisOut <- cbind(thisOut,thisIn[,2])
  newChromMat <- rbind(newChromMat,thisOut)
}
chromNames <- paste(newChromMat[,1],newChromMat[,2],sep=":")
newMap <- cbind(newChromMat[,1],chromNames,map[,3:4])
write.table(newMap,file="Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly.map",
            row.names=FALSE,col.names=FALSE,quote=FALSE)