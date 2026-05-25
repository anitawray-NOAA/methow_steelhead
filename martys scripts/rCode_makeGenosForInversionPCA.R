#make a pca using genotypes only in the inversion region, expecting three clusters

setwd("~/Documents/Methow_steelhead/RAD/filter_1-2025")
library(GENESIS)
library(SeqArray)
library(SNPRelate)
library(vcfR)
library(GWASTools)

pcaSNPs <- read.table("inversion_snps",header=FALSE)[,1]
gdsSubset(parent.gds="gds",sub.gds="inversion_gds",snp.include=pcaSNPs)
