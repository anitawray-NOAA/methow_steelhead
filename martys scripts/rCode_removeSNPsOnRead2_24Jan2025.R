setwd("/Users/martin.kardos/Documents/Methow_steelhead/RAD")
# identify snps > 140 bp from cut site and remove them
hwe <- read.table("Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8.hwe", header=TRUE)

sbf1 <- read.table("sbf1LocationStartsOmyk2.0", header=TRUE)

# calculate distance to a sbf1 cut site

chroms <- unique(hwe$CHR)
dists <- NULL # save distance between each SNP and an sbf1 cut site
for(i in 1:length(chroms)){
  theseSNPs <- hwe[which(hwe$CHR == chroms[i]),2]
  theseCuts <- sbf1[which(sbf1$chrNameVec == chroms[i]),2]
  theseDists <- rep(NA,length(theseSNPs))
  for(j in 1:length(theseDists)){
    theseDists [j] <- min(abs(theseSNPs[j] - theseCuts ))
  }

  thisChrom <- rep(chroms[i],length(theseDists))
  out <- cbind(thisChrom,theseDists,theseSNPs)
  dists <- rbind(dists,out)
  print(i)
}

keep <- dists[which(as.numeric(dists[,2]) <= 120),]
keep <- keep[,c(1,3)]
write.table(keep,file="keepReadOneSNPsOnly",quote=FALSE,row.names=FALSE,col.names=FALSE,sep="\t")