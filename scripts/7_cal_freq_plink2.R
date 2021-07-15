#!/usr/bin/env Rscript

###################################################################
##calculate frequncy in each bin for different phenotypes      ####  
###################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--bfile"), type = "character", default = NULL, help = "Full path to the directory of plink bfile"),
  make_option(c("--bin_dir"), type = "character", default = NULL, help = "Directory to the files storing bin files for each phenotype generated in splitBins.R"),
  make_option(c("--pheno"), type = "character", default = NULL, help = "phenotype name"),
  make_option(c("--bin_number"), type = "character", default = NULL, help = "Bin number"),
  make_option(c("--outdir"), type = "character", default = NULL, help = "Full path and prefix of .afreq output file"),
  make_option(c("--summary_bins_file"), type = "character", default = NULL, help = "Full path to output file summarising number of splitted bins for all phenotypes"),
  make_option(c("--nthreads"), type = "character", default = 1, help = "Number of threads used")
)

opt <- parse_args(OptionParser(option_list=option_list))


bfile <- opt$bfile
bin_dir <- opt$bin_dir
pheno <- opt$pheno
bin <- as.numeric(opt$bin_number)
outdir <- opt$outdir
binfile <- opt$summary_bins_file
threads <- opt$nthreads

bin_sums <- fread(binfile)
bins <- bin_sums[PHENO == pheno, Bins]

if(bin <= bins){
  for(chr in 1:22){
    system(paste0("plink2 --bfile ", bfile, "/ukb_eurs_qcs_chr", chr, " --keep ", bin_dir, "/", pheno, "_Bin", bin, ".txt --freq --threads ", threads, "  --out ", outdir, "/ukb_eurs_qcs_chr", chr, "_", pheno, "_Bin", bin)) 
  }
} else{
  print("No such bin file")
}

