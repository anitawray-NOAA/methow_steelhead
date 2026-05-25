setwd("~/Documents/Methow_steelhead/RAD/filter_1-2025")




depth <- read.table("Methow_RAD.idepth",header=TRUE)
keepInds <- NULL
keepInds <- cbind(keepInds,depth[which(depth$MEAN_DEPTH > 2),1])
write.table(keepInds,"keepInds_depth",quote=FALSE,col.names=FALSE,row.names=FALSE,sep="\t")

