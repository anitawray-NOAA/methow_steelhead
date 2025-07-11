# process Methow RADSeq data
setwd("~/Desktop/methow_steelhead/raw/")
packages <- c('GENESIS', 'SeqArray', 'SNPRelate', 'vcfR', 'GWASTools')

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))
#theme_set(theme_classic())




#############################
### convert to gds format
#############################

#------------------------------------------------------------------------------------------
# make a new vcf file that has numerical chromosome names from binary plink files on SEDNA
# the chromosome names are changed to 1:29 to conform to PLINK formatting
#------------------------------------------------------------------------------------------
#srun plink --bfile Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly  --chr-set 29 --recode vcf --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms.vcf

# remove individual that do not have phenotype data
# srun vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms.vcf --remove removeIndsNoPhenos --recode --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds

# correct ID names in input vcf with script rCode_fixIDNamesInGenesisInputVCF.R


# convert the vcf file that includes only individuals that have measured phenotypes to a GDS
snpgdsVCF2GDS("Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds_corrNames.vcf",
              "gds")

gds_genoReader <- GdsGenotypeReader("gds")
gds_samples <- getScanID(gds_genoReader)


# make genotype reader format data

# convert gds to genotypes
gds_genos<-GenotypeData(gds_genoReader)

# convert genotypes to genotype iterator for input into GWAS
gds_genos_iterator <-GenotypeBlockIterator(gds_genos,snpBlock=20000)




#####################################
# process phenotypes and IDs
#####################################
library(reshape2)
phenos <- read.table("pheno_data.txt",header=TRUE)
phenos <- phenos[order(phenos$Fin_Clip_Number),]

IDs <- read.table("GenIDs_SampIDs_10Feb2025.txt",header=TRUE) # read in the ID Key
# make ids conform to genomic data
idMat <- colsplit(IDs[,4],pattern="_",names=c("lib","ind"))
ids2 <- idMat[,1]
ids2[which(nchar(idMat[,1]) == 2)] <- paste("L0",substr(ids2 [which(nchar(idMat[,1]) == 2)],start=2,stop=2),sep="")
IDs$geno_ID <- paste(ids2,"_",idMat[,2],sep="")

phenoIDMat <- matrix(NA,nrow=nrow(phenos),ncol=2)
colnames(phenoIDMat) <- c("Fin_clip","GenoID")
phenoIDMat[,1] <- phenos$Fin_Clip_Number

for(i in 1:nrow(IDs)){
  phenoIDMat[which(phenoIDMat[,1] == IDs$sample_ID[i]),2] <- IDs$geno_ID[i]
}

# prune the phenotypic data to include only individuals with phenotypic and genomic data

keepInds <- which(phenoIDMat[,2] %in% gds_samples == TRUE)  # identify individuals with both phenotypes and genomic data
phenoIDMat <- phenoIDMat[keepInds,]       
phenos <- phenos[keepInds,]
phenos <- cbind(phenoIDMat,phenos)

# check alignment. This needs to = 0
sum(phenos[,1] != phenos$Fin_Clip_Number)

# keep only the data needed for a GWAS
phenosOut <- phenos[,c(2,3,5,6,9,10,11,13,14,15,16,17,18,19,21:25)]

for(i in 1:ncol(phenosOut)){
  if(sum(phenosOut[,i] == "*",na.rm=TRUE) > 0){
    phenosOut[which(phenosOut[,i] == "*"),i] <- NA 
  }
}

# make a binary smoltification indicator variable
smolt_bin <- rep(NA,nrow(phenosOut))
smolt_bin[which(phenosOut$SI_text == "Smolt" | phenosOut$SI_text == "Transitional")] <- 1
smolt_bin[which(phenosOut$SI_text != "Smolt" & phenosOut$SI_text != "Transitional")] <- 0
phenosOut <- cbind(phenosOut,smolt_bin)
#rename ID to make compatible with gds format
colnames(phenosOut)[1] <- "scanID"

# align phenotype file with genotype files order
phenosOut2 <- phenosOut[match(gds_samples,phenosOut$scanID),]
# process time (between tagging and smoltification assessment)

tag_date <- as.numeric(as.Date(phenosOut2$Tag_Date,format='%m/%d/%Y'))
SA_Date <- as.numeric(as.Date(phenosOut2$SA_date,format='%m/%d/%Y'))
days <- SA_Date - tag_date
growth <- (as.numeric(phenosOut2$WT) - phenosOut2$Weight)/days
phenosOut2 <- cbind(phenosOut2,growth)
write.table(phenosOut2,file="phenosOut2",quote=FALSE,row.names=FALSE)

# scan the phenotype annotation file for GENESIS
scanAnnot_phenos <-ScanAnnotationDataFrame(phenosOut2)



###################
# kinship matrix
###################
#king: run the following line of code in the data directory on the linux terminal on SEDNA, after converting the vcf file to PLINK format with make_plink_bed_2.sh script and changing chromosome names with rCode_changeMapFileChromNames.R
# conda activate king-2.2.7
# srun king -b Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds_corrNames.bed --prefix methow_kinship --kinship

#convert king kinship estimates to matrix format
kinMatrix<-kingToMatrix(king="methow_kinship.kin0",estimator ="Kinship")

# PCAir PCs
PCAir <- pcair(gds_genoReader,kinobj=kinMatrix,divobj=kinMatrix)

# matrix of PCs
PCAirRes<- PCAir$vectors

# get kinship coefficients from PC-Relate
PCrelate_kins <- pcrelate(gds_genos_iterator,PCAirRes)

# Convert to a vkinship matrix for GWAS
PCrelate_mat <- pcrelateToMatrix(PCrelate_kins)
# read in map file with the correct chromosome names
map <- read.table("Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds_corrNames.map",header=FALSE)

##############################################################################################
# smoltification GWAS
##############################################################################################

#fit null model for smoltification
smolt_bin_null_mod <- fitNullModel(scanAnnot_phenos, outcome="smolt_bin", covars=c("growth"), 
                              cov.mat=PCrelate_mat, family=binomial)

#GWAS
s<-assocTestSingle(gds_genos_iterator, null.model = smolt_bin_null_mod,
                               test="Score") 


# manhattan plot
gap <- 10
chrom_gwas <- unique(s$chr)
resMat <- s
resMat$chr <- map[,1]
chroms <- unique(resMat$chr)
chrLengs <- rep(NA,length(chroms))
for(i in 1:length(chroms)){
  chrLengs[i] <- max(resMat[which(resMat$chr == chroms[i]),3])
}
xMax <- sum(chrLengs)/1000000 + gap*28

library(scales)
plot(c(0,xMax),c(0,6),type="n",axes=FALSE,xlab="Genomic Position",ylab="-log10(P)")
xIter <- 0
cols <- rep(c("blue","orange"),20)
for(i in 1:length(chroms)){
  thisDat <- resMat[which(resMat$chr == chroms[i]),]
  points(xIter + thisDat$pos/1000000,-1*log10(thisDat$Score.pval),col=alpha(cols[i],alpha=0.3),
         pch=16,cex=0.9)
  xIter <- xIter+gap+max(thisDat$pos/1000000)
}

axis(side=2,at=seq(0,6,1))

##############################################################################################
# growth GWAS
##############################################################################################


#fit null model for growth
growth_null_mod <- fitNullModel(scanAnnot_phenos, outcome="growth",  covars=c("Tank"),
                                   cov.mat=PCrelate_mat, family="gaussian")

# Heritability
varCompCI(growth_null_mod, prop = TRUE)

#GWAS
growth_GWAS <-assocTestSingle(gds_genos_iterator, null.model = growth_null_mod,
                   test="Score") 
gap <- 10
# manhattan plot
chrom_gwas <- unique(growth_GWAS$chr)
resMat <- growth_GWAS
resMat$chr <- map[,1]
chroms <- unique(resMat$chr)
chrLengs <- rep(NA,length(chroms))
for(i in 1:length(chroms)){
  chrLengs[i] <- max(resMat[which(resMat$chr == chroms[i]),3])
}
xMax <- sum(chrLengs)/1000000 + gap*28

library(scales)
plot(c(0,xMax),c(0,6),type="n",axes=FALSE,xlab="Genomic Position",ylab="-log10(P)")
xIter <- 0
cols <- rep(c("blue","orange"),20)
for(i in 1:length(chroms)){
    thisDat <- resMat[which(resMat$chr == chroms[i]),]
    points(xIter + thisDat$pos/1000000,-1*log10(thisDat$Score.pval),col=alpha(cols[i],alpha=0.3),
           pch=16,cex=0.9)
    xIter <- xIter+gap+max(thisDat$pos/1000000)
}

axis(side=2,at=seq(0,6,1))


##########################################################
###### plot just chromosome five p-values
##########################################################

# manhattan plot

library(scales)
thisDat <- resMat[which(resMat$chr == 5),]
xMax <- max(thisDat$pos)/1000000
xMin <- min(thisDat$pos)/1000000
plot(c(0,xMax),c(0,6),type="n",axes=FALSE,xlab="Genomic Position (Mb)",ylab="-log10(P)")
xIter <- 0

points(thisDat$pos/1000000,-1*log10(thisDat$Score.pval),col=alpha("blue",alpha=0.3),
         pch=16,cex=1.5)

axis(side=2,at=seq(0,6,1))
axis(side=1,at=seq(0,100,10))

#######################################################
# make another omy5 manhattan plot with an LD matrix
#######################################################
par(mfrow=c(2,1),mar=c(0.5,6,1,4),xpd=TRUE)

ld2 <- as.matrix(read.table("LD_omy5_1Kloci",header=FALSE))
snpInfo2 <- read.table("LD_omy5_1Kloc_snpInfo",header=FALSE)

numLoci <- nrow(snpInfo2)
plot(c(1,numLoci),c(0,numLoci),ylim=c(-0.19*numLoci,numLoci),type="n",axes=FALSE,ylab="",xlab="")

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

chromPos <- -0.15*numLoci

lines(c(0,nrow(ld2)),y=c(chromPos,chromPos),lwd=1)
relPos <- (snpInfo2[,3] - min(snpInfo2[,3]))/max(snpInfo2[,3] - min(snpInfo2[,3]))
sampLoci <- c(seq(1,nrow(snpInfo2),5),nrow(snpInfo2))
plotPos <- snpInfo2[sampLoci,]
plotPos[,3] <- plotPos[,3]/1000000
for(i in 1:nrow(plotPos)){
  lines(x=c(sampLoci[i],relPos[sampLoci[i]]*numLoci),y=c(0,chromPos))
}
par(xpd=TRUE)
#text(x=seq(0,prunNum,100),y=c(-0.2*prunNum,-0.2*prunNum),labels=seq(0,snpInfo2[nrow(snpInfo2),3]/1000000,10))
xPos <- c(0,seq(10,90,10),round(snpInfo2[nrow(snpInfo2),3]/1000000,digits=1))
plotXPos <- 0 + (xPos/max(xPos))*numLoci
text(plotXPos,y=rep(-0.19*numLoci,length(plotXPos)),labels=xPos)

# make a color ramp legend
xstarts <- 0
ystarts <- seq(500,950,50)
for(i in 1:10){
  rect(xleft=xstarts,xright=xstarts+50,ybottom=ystarts[i],ytop=ystarts[i]+50,col=ramp[i])
}
text(x=100,y=1050,labels=expression(italic(""*r*"")))
rstarts <- seq(0,0.9,0.1)
rends <- rstarts + 0.1
for(i in 1:10){
  text(x=100,y=ystarts[i]+25,labels= paste(rstarts[i]," - ",rends[i],sep=""),cex=0.75)
}
#------------------------------------------------
# add manhattan plot
#------------------------------------------------

par(mar=c(5,6,1,4))


# manhattan plot

library(scales)
thisDat <- resMat[which(resMat$chr == 5),]
xMax <- max(thisDat$pos)/1000000
xMin <- min(thisDat$pos)/1000000
plot(c(0,xMax),c(0,6),type="n",axes=FALSE,xlab="Position on Omy5 (Mb)",ylab="-log10(P)")
xIter <- 0
points(thisDat$pos/1000000,-1*log10(thisDat$Score.pval),col=alpha("blue",alpha=0.3),
       pch=16,cex=1.5)

axis(side=2,at=seq(0,6,1))
axis(side=1,at=seq(0,100,10))








############################################################################
# make another omy5 manhattan plot with an LD matrix with physical position
############################################################################
par(mfrow=c(2,1),mar=c(0.5,6,1,4),xpd=TRUE)

ld2 <- as.matrix(read.table("LD_omy5_1Kloci",header=FALSE))
snpInfo2 <- read.table("LD_omy5_1Kloc_snpInfo",header=FALSE)

numLoci <- nrow(snpInfo2)
plot(c(0.5,101),c(0,101),type="n",ylab="",xlab="",axes=FALSE)

# make a color ramp 
palette <- colorRampPalette(rev(c("blue", "orange", "red")), space = "rgb")
ramp <- rev(palette(10))
for(i in 1:(nrow(ld2)-1) ){
  scores <- ceiling(ld2[i,(i+1):ncol(ld2)]*10)
  focalPos <- snpInfo2[i,3]
  otherPos <- snpInfo2[(i+1):nrow(snpInfo2),3] 
  cols <- ramp[scores]
  #xs <- seq(from=i+0.5,to = (length(scores)-1)*0.5 + i + 0.5,by=0.5)
  xs <- rowMeans(cbind(rep(focalPos,length(otherPos)),otherPos))/1000000
  ys <- ((otherPos - focalPos)/1000000)
  #ys <- (1:length((i+1):numLoci))
  points(x = xs,y = ys,pch=18,col=cols,cex=0.5)
} 


# make a color ramp legend
xstarts <- 0
ystarts <- seq(60,100,4)
for(i in 1:10){
  rect(xleft=xstarts,xright=xstarts+4,ybottom=ystarts[i],ytop=ystarts[i]+4,col=ramp[i])
}
text(x=100,y=1050,labels=expression(italic(""*r*"")))
rstarts <- seq(0,0.9,0.1)
rends <- rstarts + 0.1
for(i in 1:10){
  text(x=10,y=ystarts[i]+2,labels= paste(rstarts[i]," - ",rends[i],sep=""),cex=0.75)
}

axis(side=1,at=seq(0,100,10))

text(x=10,y=104,labels=expression(italic(""*r*"")))
#------------------------------------------------
# add manhattan plot
#------------------------------------------------

par(mar=c(5,6,2,4))


# manhattan plot

library(scales)
thisDat <- resMat[which(resMat$chr == 5),]
xMax <- max(thisDat$pos)/1000000
xMin <- min(thisDat$pos)/1000000
plot(c(0,xMax),c(0,6),type="n",axes=FALSE,xlab="Position on Omy5 (Mb)",ylab="-log10(P)")
xIter <- 0
points(thisDat$pos/1000000,-1*log10(thisDat$Score.pval),col=alpha("blue",alpha=0.3),
       pch=16,cex=1.5)

axis(side=2,at=seq(0,6,1))
axis(side=1,at=seq(0,100,10))

###################################################################################
#make a pca using genotypes only in the inversion region, expecting three clusters
###################################################################################

pcaSNPs <- thisDat$variant.id[which(thisDat$pos >= 33000000 & thisDat$pos <= 87000000)]
rm(list=ls())
gc()
gdsSubset(parent.gds="gds",sub.gds="inversion_gds",snp.include=pcaSNPs)

# make a gds for all snps on chrom 5 for LD analysis

ldSNPs <- thisDat$variant.id
ldSNPInfo <- thisDat[,1:3]
write.table(ldSNPInfo,file="ld_snp_info",quote=FALSE,row.names=FALSE,col.names=TRUE)
rm(list=ls())
gc()
ldSNPMat <- read.table("ld_snp_info",header=TRUE)

gdsSubset(parent.gds="gds",sub.gds="ld_gds",snp.include=ldSNPMat$variant.id)



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


