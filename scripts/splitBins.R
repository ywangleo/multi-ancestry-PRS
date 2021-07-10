#!/usr/bin/env Rscript

###################################################################
##randomly split into bins with 5K for different phenotypes    ####  
###################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--phenofile"), type = "character", default = NULL, help = "Full path to phenotype files with IID included in the headers"),
  make_option(c("--all_phenos"), type = "character", default = NULL, help = "a vector of phenotypes, separated by comma"),
  make_option(c("--rel05_list"), type = "character", default = NULL, help = "Full path to the file listing all unrelated individuals in that specific ancestry (in the order of FID, IID)"),
  make_option(c("--holdout"), type = "character", default = NULL, help = "Full path to the file listing hold-out sample ids (FID, IID)"),
  make_option(c("--outdir"), type = "character", default = NULL, help = "Full path to the directory of output file storing ids as well as phenotype for each phenotype per bin"),
  make_option(c("--summary_bins_file"), type = "character", default = NULL, help = "Full path to output file summarising number of splitted bins for all phenotypes")
)

opt = parse_args(OptionParser(option_list=option_list))

phenofile <- opt$phenofile
phenames <- opt$all_phenos
phenames1 <- strsplit(phenames,",")[[1]]
rel05 <- opt$rel05_list
hold_out <- opt$holdout
outdir <- opt$outdir
binfile <- opt$summary_bins_file


phes <- fread(phenofile)
ids <- fread(rel05, header = F)
phes1 <- phes[IID %in% ids$V2] 
holdout <- fread(hold_out, header = F)
phes1 <- phes1[!IID %in% holdout$V2]

split_data_table <- function(x, no_rows_per_frame, prefix_to_store){
  
  split_vec <- seq(1, nrow(x), no_rows_per_frame)
  
  for (i in 1:(length(split_vec) - 1)) {
    split_cut <- split_vec[i]
    sample <- x[split_cut : (split_cut + (no_rows_per_frame-1))]
    fwrite(sample, paste0(prefix_to_store,  i, ".txt"), sep = "\t")
  }
}

sums <- data.table()
for(PHENO in phenames1){
  names <- c("IID", "IID", PHENO)
  tmp <- phes1[,..names]
  tmp1 <- na.omit(tmp)
  Bins <- floor(nrow(tmp1)/5000)
  counts <- data.table(PHENO, Bins)
  sums <- rbind(sums, counts)
  
  names(tmp1) <- c("FID", "IID", PHENO)
  set.seed(1234)
  tmp2 <- tmp1[sample(nrow(tmp1), nrow(tmp1))]
  split_data_table(x = tmp2, no_rows_per_frame = 5000, 
                   prefix_to_store = paste0(outdir, "/", PHENO, "_Bin"))
}

fwrite(sums, file = binfile, sep = "\t")

