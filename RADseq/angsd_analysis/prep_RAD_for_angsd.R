
## File prep for loco-pipe

## Prepare sample table -- I put treatment as population -- can change it
setwd(dir = "~/Desktop/methow_steelhead/RADseq/")
library(tidyverse)

bam_list <- read.delim(file = "bam_files_RAD.txt", header = F) %>%
  subset(V1 != "bam_files_RAD.txt")

bam_list$bam <- paste("/scratch2/awray/methow_RAD/bams/",bam_list$V1, sep = "")

bam_list$sample_name <- sub(".RG.bam", "", bam_list$V1)


bam_list <- bam_list %>%
  select(-c('V1'))

metadata <- read.delim("phenosOut2") %>%
  subset(scanID %in% bam_list$sample_name)

bam_list <- bam_list %>%
  subset(sample_name %in% metadata$scanID)

#write_csv(metadata, file = "WGS_metadata_11_20_25_AW.csv")

population <- metadata %>%
  select("scanID", "Treatment")

colnames(population) <- c('sample_name', 'population')

#sample_table <- merge(bam_list, population)

#write_tsv(sample_table, file = "sample_table.tsv")

#bam_list$sample_name <- paste("omy", bam_list$sample_name, sep = "_")


## Get PCs for covariates

PCs <- read.delim(file = "pcangsd_all_pops_all_phenos.cov", header =F, sep = " ") %>%
  select(c("V1","V2"))

#metadata <- metadata[match(sample_order_in_vcf$V1, metadata$Fin_Clip_Number), ] #make sure the order is the same


#metadata[which(!metadata$scanID %in% PCs$taxa),1]

metadata <- cbind(metadata, PCs)

#metadata$Tank...7 == metadata$Tank

metadata <- metadata[match(bam_list$sample_name, metadata$scanID), ] #make sure the order is the same

write_delim(metadata %>% select(c("Tank", "V1", "V2")), 
            file = "RAD_tank_cov_all_pops_2PCs.txt", col_names = FALSE)
write_delim(metadata %>% select("growth"),
            file = "growth_pheno_RAD_all_pops.txt", col_names = FALSE)
write_delim(bam_list,
            file = "bam_list_with_phenos.txt")
