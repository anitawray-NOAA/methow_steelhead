## GAPIT TEST


install.packages("remotes")
remotes::install_github("jiabowang/GAPIT")
library(GAPIT)
library(vcfR)
library(tidyverse)
setwd("~/Desktop/methow_steelhead/raw/")

vcf <- read.vcfR(file = "Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_minGQ30_maxMiss0.8_read1SNPsOnly_numChroms_allPhenInds_corrNames.vcf")

genotype_data <- vcfR2hapmap(vcf)

#genotype_data <- genotype_data[-1,]

genotypes <- colnames(genotype_data)

genotypes <- genotypes[!(genotypes %in% c("rs","alleles","chrom","pos","strand","assembly",
                                         "center","protLSID","assayLSID","panel","QCcode"))]

phenotype_data <- read.delim("phenosOut2", sep = " ")


covariate_data <- phenotype_data %>%
  select(c('Taxa', 'Tank'))


phenotype_data$Taxa == genotypes

growth <- phenotype_data[,c("Taxa", 'growth')]

NA_growth <- growth %>%
  subset(is.na(growth)) %>%
  select(c("Taxa"))

growth_na_rm <- growth %>%
  subset(!is.na(growth))

NA_growth_taxa <- NA_growth$Taxa

genotypes_NA_rm <- genotype_data %>%
  select(-one_of(NA_growth_taxa))

covariate_data_na_rm <- covariate_data %>%
  subset(!Taxa %in% NA_growth_taxa)

#write.csv(growth, file = "example_phenotype_file.csv")

kinship_data <- read.delim("GAPIT.Genotype.Kin_Zhang.csv", header = F, sep = ',')


write.csv(genotypes_NA_rm, file = "genotype_data_example.csv")
write.csv(covariate_data_na_rm, file = 'covariate_data_example.csv')
write.csv(phenotype_data, file = 'phenotype_data_example.csv')

myGAPIT <- GAPIT(
  Y=growth_na_rm,
  G=genotypes_NA_rm,
  CV=covariate_data_na_rm,
  #KI=kinship_data,
  PCA.total=2)












