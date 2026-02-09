### GWAS plotting from GEMMA

#install.packages("qqman")
library(qqman)

setwd("~/Desktop/methow_steelhead/raw/")

gwas_df<-read.table("growth_lmm4.assoc.txt", header = T)


hist(gwas_df$p_lrt)


gwas_df$SNP<-paste("r",1:length(gwas_df$chr), sep="")

gwas_df$pvalue<-pchisq(gwas_df$p_lrt, df=1, lower=F)

padj <- p.adjust(gwas_df$pvalue, method = "BH")
alpha <- 0.05
outliers <- which(padj < alpha)
length(outliers)
newp <- 0.05/60747

pdf("figures/GWAS_plot_growth_GEMMA.pdf", width = 9, height = 4.5)
manhattan(gwas_df, chr="chr", bp="ps", p="p_lrt", suggestiveline = (-1*log10(0.05/60747)))
dev.off()


gwas_df<-read.table("smoltification_lmm4.assoc.txt", header = T)


hist(gwas_df$p_lrt)


gwas_df$SNP<-paste("r",1:length(gwas_df$chr), sep="")

gwas_df$pvalue<-pchisq(gwas_df$p_lrt, df=1, lower=F)

padj <- p.adjust(gwas_df$pvalue, method = "BH")
alpha <- 0.05
outliers <- which(padj < alpha)
length(outliers)
newp <- 0.05/60180

pdf("figures/GWAS_plot_smolt_GEMMA.pdf", width = 9, height = 4.5)
manhattan(gwas_df, chr="chr", bp="ps", p="p_lrt", suggestiveline = (-1*log10(0.05/60180)))
dev.off()
