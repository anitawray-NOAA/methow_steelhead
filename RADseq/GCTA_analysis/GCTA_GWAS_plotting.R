
library(qqman)

setwd("Desktop/methow_steelhead/")
NCHR <- 29   #Set "number_of_chromosomes" to the correct value for your species

#Load the GCTA output file
gwasResults <- read.table('gwas_run1.mlma', header = TRUE)

# Calculate the 5% significance level for the genome-wide ("Thrgen") and the chromosome-wide ("Thrchr") levels
Thrgen <- -log10(0.05/nrow(gwasResults))
Thrchr <- -log10(0.05/(nrow(gwasResults)/NCHR))


pdf("figures/GWAS_plot_growth_GCTA.pdf", width = 9, height = 4.5)

#Draw the Manhattan plot
manhattan(gwasResults, chr = "Chr", bp="bp", snp ="SNP", 
          p="p", 
          col = c("blue", "orange", 'forestgreen', 'purple'), 
          #suggestiveline = Thrchr, 
          genomewideline = Thrgen)
dev.off()

qq(gwasResults$p, main = "Q-Q plot of GWAS p-values")
