
## File prep for loco-pipe

## Prepare sample table -- I put treatment as population -- can change it
setwd(dir = "Desktop/methow_steelhead/WGS/")
library(tidyverse)

bam_list <- read.delim(file = "bam_files.txt", header = F)

bam_list$bam <- paste("/scratch2/awray/methowWGS/bams/",bam_list$V1, sep = "")

bam_list$sample_name <- sub(".bam", "", bam_list$V1)

bam_list <- bam_list %>%
  select(-c('V1'))


metadata <- read.delim("Methow_WGStosample_ECandLC.tsv") %>%
  subset(Fin_Clip_Number %in% bam_list$sample_name)

write_csv(metadata, file = "WGS_metadata_11_20_25_AW.csv")


population <- metadata %>%
  select("Fin_Clip_Number", "Treatment")

colnames(population) <- c('sample_name', 'population')

sample_table <- merge(bam_list, population)

write_tsv(sample_table, file = "sample_table.tsv")


## Prepare chromosome table 





