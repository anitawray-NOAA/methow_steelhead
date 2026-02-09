
library(tidyverse)
library(stats)
library(qqman)

## Procestats## Process LRT values 

lrt <- read.delim("Desktop/methow_steelhead/smolt_binary.res.lrt0") %>%
  subset(LRT != -999)
#lrt$Chromosome <- as.numeric(lrt$Chromosome)

lrt_pvalues <- lrt %>%
  mutate(abs_diff = -(log10(exp(1)) * pchisq(LRT, df = 1, lower.tail = FALSE, log.p = TRUE))) %>%
  rename(Chromosome = Chromosome, position = Position)

chr_nums <- read.delim("Desktop/methow_steelhead/chr_map.txt", header = F)
colnames(chr_nums) <- c('Chromosome', 'Chr_Num')

lrt_plotting_data <- merge(lrt_pvalues, chr_nums)

manhattan(lrt_plotting_data,chr="Chr_Num",bp="position",p="abs_diff",snp="position",ylim=c(0,15),
          suggestiveline=FALSE)


