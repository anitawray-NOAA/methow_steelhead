## GAPIT TEST


#install.packages("remotes")
#remotes::install_github("jiabowang/GAPIT")
source("https://raw.githubusercontent.com/jiabowang/GAPIT/refs/heads/master/gapit_functions.txt", encoding = "UTF-8")
#library(GAPIT)
library(vcfR)
library(tidyverse)
setwd("~/Desktop/methow_steelhead/raw/")

vcf <- read.vcfR(file = "Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds_corrNames.vcf")

genotype_data <- vcfR2hapmap(vcf)

#genotype_data <- genotype_data[-1,]

genotypes <- colnames(genotype_data)

#genotypes <- genotypes[!(genotypes %in% c("rs","alleles","chrom","pos","strand","assembly",
#                                         "center","protLSID","assayLSID","panel","QCcode"))]

phenotype_data <- read.delim("phenosOut2", sep = " ")


covariate_data <- phenotype_data %>%
  select(c('scanID', 'Tank'))


phenotype_data$scanID == genotypes[12:length(genotypes)] ## first 11 are a bunch of descriptors

colnames(phenotype_data)

phenos <- phenotype_data[,c("scanID", 'growth', "SWC_mort_14_day", "X48.hr.SWC.mort", "smolt_bin")]

sum(is.na(phenos$SWC_mort_14_day))
sum(is.na(phenos$X48.hr.SWC.mort))
sum(is.na(phenos$smolt_bin)) ##64
sum(is.na(phenos$growth)) ##64 it looks like these are the same samples so let's get rid of them

NA_phenos <- phenos %>%
  subset(is.na(growth)) %>%
  select(c("scanID"))

phenos_na_rm <- phenos %>%
  subset(!is.na(growth))

NA_phenos_scanID <- NA_phenos$scanID

genotypes_NA_rm <- genotype_data %>%
  select(-one_of(NA_phenos_scanID))

covariate_data_na_rm <- covariate_data %>%
  subset(!scanID %in% NA_phenos_scanID)

#write.csv(growth, file = "example_phenotype_file.csv")

#kinship_data <- read.delim("GAPIT.Genotype.Kin_Zhang.csv", header = F, sep = ',')


#write.csv(genotypes_NA_rm, file = "genotype_data_example.csv")
#write.csv(covariate_data_na_rm, file = 'covariate_data_example.csv')
#write.csv(phenotype_data, file = 'phenotype_data_example.csv')

setwd("~/Desktop/methow_steelhead/")
#dir.create("GAPIT_Results_wPCs") ## GAPIT won't let you change the output names, so make new folders
setwd("GAPIT_Results_wPCs/")

myGAPIT <- GAPIT(
  Y=phenos_na_rm,
  G=genotypes_NA_rm,
  CV=covariate_data_na_rm,
  #KI=kinship_data,
  PCA.total=2,
  model = c("MLMM, MLM"))

myGM <- genotypes_NA_rm

GAPIT.Power.compare(
  G=genotypes_NA_rm,
  CV=covariate_data_na_rm,
  KI=kinship_data,
  #PCA.total=2,
  nrep=10,
  h2=0.9,
  model =c("MLM","MLMM"),
  NQTN=5)










