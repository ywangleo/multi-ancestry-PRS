#!/usr/bin/env Rscript

###################################################################
##Run GWAS in each bin for different phenotypes                ####  
###################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--bfile_prefix"), type = "character", default = NULL, help = "Full path to genoytype files (Here bfile format is used)"),
  make_option(c("--phenodir"), type = "character", default = NULL, help = "Full path to the directory of phenotype file for each bin generated in splitBins.R"),
  make_option(c("--pheno"), type = "character", default = NULL, help = "Phenotype name to run GWAS"),
  make_option(c("--bin_number"), type = "character", default = NULL, help = "The No. of bin to run GWAS"),
  make_option(c("--n_threads"), type = "character", default = 1, help = "Number of threads to run PLINK2"),
  make_option(c("--summary_bins_file"), type = "character", default = NULL, help = "Full path to output file summarising number of splitted bins for all phenotypes"),
  make_option(c("--out_prefix"), type = "character", default = NULL, help = "Prefix with full path to the output file of GWAS results for each phenotype per bin")
)

opt = parse_args(OptionParser(option_list=option_list))

bfile_prefix <- opt$bfile_prefix
phenodir <- opt$phenodir
pheno <- opt$pheno
bin <- as.numeric(opt$bin_number)
n_threads <- opt$n_threads
binfile <- opt$summary_bins_file
out_prefix <- opt$out_prefix

bin_sums <- fread(binfile)
bins <- bin_sums[PHENO == pheno, Bins]

if(bin <= bins){
  system(paste0("plink2 --bfile ", bfile_prefix, " --pheno ", phenodir, "/", pheno, "_Bin", bin, ".txt --ci 0.95 --linear --freq --pheno-name ", pheno, " --threads ", n_threads, " --out ", out_prefix, "_", pheno, "_Bin", bin))
} else{
  print("No such bin file")
}
