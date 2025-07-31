setwd("~/Desktop/methow_steelhead/raw/")
library(tidyverse)
library(ggsignif)
library(reshape2)
theme_set(theme_classic())
##### read in metadata #####
phenos <- read.delim("pheno_data_NA_repl.txt", header = TRUE)
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

gds_samples <- read.table('../samples_in_gds_file.txt')

# prune the phenotypic data to include only individuals with phenotypic and genomic data

keepInds <- which(phenoIDMat[,2] %in% gds_samples$x == TRUE)  # identify individuals with both phenotypes and genomic data
phenoIDMat <- phenoIDMat[keepInds,]       
phenos <- phenos[keepInds,]
phenos <- cbind(phenoIDMat,phenos)

# check alignment. This needs to = 0
sum(phenos[,1] != phenos$Fin_Clip_Number)

# make a binary smoltification indicator variable
phenos <- phenos %>%
  mutate(smolt_bin = case_when(
    SI_text == "Smolt" | SI_text == "Transitional" ~ 1,
    SI_text != "Smolt" & SI_text != "Transitional" ~ 0))

# fill in the NA values for the 48 hour saltwater test
phenos[is.na(phenos$X48.hr.SWC.mort),25] <- 0

# process time (between tagging and smoltification assessment)
tag_date <- as.numeric(as.Date(phenos$Tag_Date,format='%m/%d/%Y'))
SA_Date <- as.numeric(as.Date(phenos$SA_date,format='%m/%d/%Y'))
days <- SA_Date - tag_date
growth <- (as.numeric(phenos$WT) - phenos$Weight)/days
phenos <- cbind(phenos,growth)

phenos$Tank <- as.factor(phenos$Tank)

#### plotting ####
pdf("figures/pheno_plots.pdf")
ggplot(data = phenos) +
  geom_boxplot(aes(x = SI_text, y = growth))

ggplot(data = phenos) +
  geom_boxplot(aes(x = as.factor(`X48.hr.SWC.mort`), y = growth))

ggplot(data = phenos) +
  geom_boxplot(aes(x = as.factor(`SWC_mort_14_day`), y = growth))

ggplot(data = phenos) +
  geom_boxplot(aes(x = as.factor(`SWC_mort_14_day`), y = Length))

ggplot(data = phenos, aes(x = as.factor(`SWC_mort_14_day`), y = Weight)) +
  geom_boxplot()+
  geom_signif(map_signif_level=TRUE, comparisons = c('0','1'))

ggplot(data = phenos) +
  geom_boxplot(aes(x = as.factor(`Treatment`), y = Length))

ggplot(data = phenos, aes(x = Treatment, y = growth)) +
  geom_boxplot() +
  geom_signif(map_signif_level=TRUE, comparisons = list(c('EC',"EW")), test = 't.test', y_position = 1.6) +
  geom_signif(map_signif_level=TRUE, comparisons = list(c('LC',"LW")), test = 't.test', y_position = 1.6) +
  geom_signif(map_signif_level=TRUE, comparisons = list(c('EC',"LC")), test = 't.test', y_position = 1.4) +
  geom_signif(map_signif_level=TRUE, comparisons = list(c('LW',"EW")), test = 't.test') +
  scale_y_continuous(limits = c(0,1.7))

ggplot(data = phenos, aes(color = Treatment, y = growth, x = as.factor(Tank))) +
  geom_boxplot() +
  geom_signif(map_signif_level=TRUE, comparisons = list(c("3","7"))) +
  geom_signif(map_signif_level=TRUE, comparisons = list(c("8","9"))) +
  geom_signif(map_signif_level=TRUE, comparisons = list(c("11","12"))) +
  geom_signif(map_signif_level=TRUE, comparisons = list(c("13","14"))) +
  scale_color_brewer(palette = "Set1")

dev.off()


