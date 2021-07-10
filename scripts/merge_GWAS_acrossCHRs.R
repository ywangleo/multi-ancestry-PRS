#!/usr/bin/env Rscript

######################################################################################
##Merge GWAS across chromosomes in each bin for different phenotypes              ####  
######################################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments


#########parsing argument options########
option_list <- list(
  make_option(c("--gwasdir"), type = "character", default = NULL, help = "Full path to the directory of GWAS outputs per chromosome for each phenotype per bin"),
  make_option(c("--out_prefix"), type = "character", default = NULL, help = "Prefix with full path to the output file of GWAS results for each phenotype per bin, specified in GWAS.sh"),
  make_option(c("--pheno"), type = "character", default = NULL, help = "Phenotype name to run GWAS"),
  make_option(c("--summary_bins_file"), type = "character", default = NULL, help = "Full path to output file summarising number of splitted bins for all phenotypes"),
  make_option(c("--bin_number"), type = "character", default = NULL, help = "The No. of bin to merge GWAS outputs"),
  make_option(c("--out_dir"), type = "character", default = NULL, help = "Full path to the directory of merged GWAS for each phenotype per bin")
)

opt = parse_args(OptionParser(option_list=option_list))

gwasdir <- opt$gwasdir
pheno <- opt$pheno
out_prefix <- opt$out_prefix
prefix <- tail(strsplit(out_prefix, "/")[[1]],1)
binfile <- opt$summary_bins_file
bin <- as.numeric(opt$bin_number)
outdir <- opt$out_dir

bin_sums <- fread(binfile)
bins <- bin_sums[PHENO == pheno, Bins]


if(bin <= bins){
  files <- list.files(path = file.path(gwasdir), pattern = glob2rx(paste0(prefix, "_", pheno, "_Bin", bin, ".*linear")), full.names = T)
  tmp <- data.table()
  for(file in files){
    gwas <- fread(file)
    tmp <- rbind(tmp, gwas)
  }
  fwrite(tmp, paste0(outdir, "/", pheno, "_Bin", bin, ".glm.linear.gz"))
#  gzip(paste0(outdir, "/", pheno, "_Bin", bin, ".glm.linear"), destname= paste0(outdir, "/", pheno, "_Bin", bin, ".glm.linear.gz"))
  print(paste0("Finished merging for ", pheno, "_Bin", bin))
} else{
  print("No such bin")
}
