# rename IDs for genesis
library(reshape2)
vcf <- readLines("Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds.recode.vcf")

names <- strsplit(vcf[35],split="\t")[[1]]
ids <- names[10:length(names)]
idMat <- NULL
idMat <- cbind(idMat,ids)
newNames <- colsplit(idMat[,1],pattern="_",names=c("c1","c2","c3","c4"))
outNames <- c(names[1:9],paste(newNames[,3],newNames[,4],sep="_"))
outChar <- paste(outNames,collapse="\t",sep="")
vcf[35] <- outChar
write.table(vcf,file="Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds_corrNames.vcf",
            quote=FALSE,row.names=FALSE,col.names = FALSE)