## Make GEMMA phenotype files and covariates file

setwd("~/Desktop/methow_steelhead/raw/")


# and phenotype file
phenos <- read.table("phenosOut2", header = T)

# get list of samples without phenos we want
missing_samps <- phenos[is.na(phenos$growth), 1]
missing_samps
#write.table(missing_samps, file = 'samples_with_no_GWAS_phenotypes.txt', row.names = F, col.names = F, quote = F)

# read .fam file 

fam_file <- read.table("plink.fam") 
fam_file$scanID <- paste(fam_file$V1, fam_file$V2, sep = "_")
order <- fam_file$scanID

#filter phenos
phenos <- phenos %>%
  subset(!scanID %in% missing_samps)


# combine the two to preserve order of 
merged <- merge(fam_file, phenos)
merged2 <- merged[order(order),]

cov_file <- merged %>%
  select(c("Tank"))

write.table(cov_file, col.names = F, row.names = F, file = 'cov_file_tank_only.txt')


write.table((merged %>% select(c('growth'))), 
            col.names = F, row.names = F, file = 'phen_file_growth_only.txt')

write.table((merged %>% select(c('SI_code'))), 
            col.names = F, row.names = F, file = 'phen_file_SI_code_only.txt')

write.table((merged %>% select(c('SWC_mort_14_day'))), 
            col.names = F, row.names = F, file = 'phen_file_14day_mort_only.txt')






