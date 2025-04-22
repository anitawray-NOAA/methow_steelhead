#make a pca using genotypes only in the inversion region, expecting three clusters

setwd("~/Documents/Methow_steelhead/RAD/filter_1-2025")
library(GENESIS)
library(SeqArray)
library(SNPRelate)
library(vcfR)
library(GWASTools)

gdsSubset(parent.gds="gds",sub.gds="omy5_gds",snp.include=pcaSNPs)
