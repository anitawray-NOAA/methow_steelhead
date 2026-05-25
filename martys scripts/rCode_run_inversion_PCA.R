
#make a pca using genotypes only in the inversion region, expecting three clusters

setwd("~/Documents/Methow_steelhead/RAD/filter_1-2025")
library(GENESIS)
library(SeqArray)
library(SNPRelate)
library(vcfR)
library(GWASTools)

genos <- snpgdsOpen("inversion_gds")
genoDat <- snpgdsGetGeno("inversion_gds",with.id=TRUE)
genoMat <- genoDat[[1]]
genoIDs <- genoDat[[2]]
pca <- snpgdsPCA(genos, num.thread=2)


# extract proportion of variance explained

propVar <- pca$varprop
head(round(pc.percent, 2))

# make a table of PCs 1 & 2
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)
head(tab)
library(scales)
plot(tab$EV1,tab$EV2,xlab="PC1 (26%)",ylab="PC2 (5%)",col=alpha("blue",alpha=0.2),pch=16)




indHet <- rowSums(genoMat == 1,na.rm=TRUE)/rowSums(is.na(genoMat) == FALSE)

################################################
# plot heterozygosity versus position on PC1
################################################

plot(tab$EV1,indHet)


###############################################
# plot growth vs pc1 and heterozygosity
###############################################

phenos <- read.table("phenoData_filtered",header=TRUE)

plot(tab$EV1,phenos$growth,col=alpha("blue",alpha=0.2),pch=16,ylab="Growth (change in mass)",xlab="PC1")

mod <- lm(phenos$growth~tab$EV1)
abline(mod)
legend(x=0.06,y=1.0,legend=expression(paste(italic(""*P*"")," = 3.6e-6")),bty="n")
