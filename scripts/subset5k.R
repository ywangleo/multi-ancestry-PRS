#!/usr/bin/env Rscript

###################################################################
##randomly sample 5K individuals as hold-out samples           ####  
###################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--phenofile"), type = "character", default = NULL, help = "Full path to phenotype files with IID or FID/IID included in the headers"),
  make_option(c("--rel05_list"), type = "character", default = NULL, help = "Full path to the file listing all unrelated individuals in that specific ancestry (in the order of FID, IID)"),
  make_option(c("--holdout_file"), type = "character", default = NULL, help = "Full path to the file storing hold-out sample ids (FID, IID)")
)

opt = parse_args(OptionParser(option_list=option_list))

phenofile <- opt$phenofile
rel05 <- opt$rel05_list
hold_out <- opt$holdout_file

phes <- fread(phenofile)
ids <- fread(rel05, header = F)
phes1 <- phes[IID %in% ids$V2] 

set.seed(1234)
if("FID" %in% names(phes1)){
  ran5k <- phes1[sample(nrow(phes1), 5000), .(FID, IID)]
} else{
  ran5k <- phes1[sample(nrow(phes1), 5000), .(IID, IID)]
}

fwrite(ran5k, file = hold_out, sep = "\t", col.names = F)




