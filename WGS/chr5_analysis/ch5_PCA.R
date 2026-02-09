##PCA from pcangsd
library(tidyverse)
library(cowplot)
setwd("~/Desktop/methow_steelhead/WGS/")
## Open R

cov <- "chr5_pcangsd.cov"
sample_table <- read_delim("sample_table.tsv")
color_by = 'population'

c <- read_delim(cov, col_names = FALSE, delim=" ") %>%
  as.matrix()
e <- eigen(c)
e_values <- e$values
var_explained <- round(e_values/sum(e_values)*100, 1)
fix_names <- function(x) str_c("PC", seq_along(x))
e_vectors <- as_tibble(e$vectors, .name_repair = fix_names) 
pca_table <- sample_table %>%
  bind_cols(e_vectors) 
## plot PCA
plot_pca <-function(axis_1, axis_2){
  pca_table %>%
    ggplot(aes(x=get(str_c("PC", axis_1)), 
               y=get(str_c("PC", axis_2)),
               color=get(color_by))) +
    geom_point(shape=21) +
    scale_color_discrete(name = color_by) +
    labs(x=str_c("PC", axis_1, " (", var_explained[axis_1],"%)"),
         y=str_c("PC", axis_2, " (", var_explained[axis_2],"%)")) +
    theme_cowplot() +
    theme(legend.position = "top",
          axis.ticks = element_blank(),
          axis.text = element_blank())
}

jpeg("ch5_inversion_PCA.jpeg")
plot_pca(1,2)
dev.off()
