## WGS loadings

setwd(dir = "Desktop/methow_steelhead/WGS/")
library(tidyverse)
weights <- read.delim("combined.subsetted.weights", header = F, sep = " ")

snp_names <- read.delim("snp_names.txt") %>%
  separate(marker, c("chr", "snp"), "_")

combined <- cbind(snp_names, weights)



ggplot(data = combined, aes(x = snp, y = V1)) +
  geom_point() +
  geom_point(data = combined %>% subset(V1 < -0.5), 
             aes(x = snp, y = V1), color = 'red')+
  facet_wrap(~chr) +
  geom_hline(yintercept = 0)
