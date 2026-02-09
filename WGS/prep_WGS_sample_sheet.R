
## File prep for loco-pipe

## Prepare sample table -- I put treatment as population -- can change it
setwd(dir = "~/Desktop/methow_steelhead/WGS/")
library(tidyverse)

bam_list <- read.delim(file = "bam_files.txt", header = F)

bam_list$bam <- paste("/scratch2/awray/methow/bams/",bam_list$V1, sep = "")

bam_list$sample_name <- sub(".bam", "", bam_list$V1)


bam_list <- bam_list %>%
  select(-c('V1'))


metadata <- read.delim("Methow_WGStosample_ECandLC.tsv") %>%
  subset(Fin_Clip_Number %in% bam_list$sample_name)

metadata$tag_date_num <- as.numeric(as.Date(metadata$Tag.Date,format='%Y-%m-%d'))
metadata$SA_Date_num <- as.numeric(as.Date(metadata$SA.date,format='%Y-%m-%d'))
metadata$days <- metadata$SA_Date_num - metadata$tag_date_num
metadata$growth <- (log(metadata$WT) - log(metadata$Weight))/metadata$days

#write_csv(metadata, file = "WGS_metadata_11_20_25_AW.csv")




population <- metadata %>%
  select("Fin_Clip_Number", "Treatment")

colnames(population) <- c('sample_name', 'population')

sample_table <- merge(bam_list, population)

#write_tsv(sample_table, file = "sample_table.tsv")

#bam_list$sample_name <- paste("omy", bam_list$sample_name, sep = "_")


## Get PCs for covariates

PCs <- read.delim(file = "tank_and_2PC_cov.txt", header = F, col.names = c("Tank", "PC1", "PC2"))

metadata <- cbind(metadata, PCs)

metadata$Tank...7 == metadata$Tank

metadata <- metadata[match(sample_table$sample_name, metadata$Fin_Clip_Number), ] #make sure the order is the same

metadata_lc_only <- metadata %>%
  subset(Treatment == "LC")


metadata_ec_only <- metadata %>%
  subset(Treatment == "EC")

sample_table$bam <- gsub("methowWGS", "methow", sample_table$bam)

write_delim(metadata_ec_only %>% select(c("Tank", 'PC1','PC2')), 
          file = "tank_and_2PC_cov_EC_only.txt", col_names = FALSE)
write_delim(metadata_ec_only %>% select("growth"),
            file = "growth_pheno_EC_only.txt", col_names = FALSE)
write_delim(sample_table %>% subset(population == 'EC') %>% select("bam"),
            file = "bam_list_EC_only.txt", col_names = FALSE)


write_delim(metadata_lc_only %>% select(c("Tank", 'PC1','PC2')), 
            file = "tank_and_2PC_cov_LC_only.txt", col_names = FALSE)
write_delim(metadata_lc_only %>% select("growth"),
            file = "growth_pheno_LC_only.txt", col_names = FALSE)
write_delim(sample_table %>% subset(population == 'LC') %>% select("bam"),
            file = "bam_list_LC_only.txt", col_names = FALSE)









