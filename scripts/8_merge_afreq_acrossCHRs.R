#!/usr/bin/env Rscript

###########################################################################################
##merge frequncy across chromosomes in each bin for different phenotypes               ####  
###########################################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--frqdir"), type = "character", default = NULL, help = "Full path to the directory of frequency outputs per chromosome for each phenotype per bin"),
  make_option(c("--out_prefix"), type = "character", default = NULL, help = "Prefix with full path to the output file of .afreq results for each phenotype per bin, specified in GWAS.sh"),
  make_option(c("--pheno"), type = "character", default = NULL, help = "Phenotype name to run .afreq"),
  make_option(c("--summary_bins_file"), type = "character", default = NULL, help = "Full path to output file summarising number of splitted bins for all phenotypes"),
  make_option(c("--bin_number"), type = "character", default = NULL, help = "The No. of bin to merge .afreq outputs"),
  make_option(c("--out_dir"), type = "character", default = NULL, help = "Full path to the directory of merged .afreq for each phenotype per bin")
)

opt = parse_args(OptionParser(option_list=option_list))

frqdir <- opt$frqdir
pheno <- opt$pheno
out_prefix <- opt$out_prefix
prefix <- tail(strsplit(out_prefix, "/")[[1]],1)
binfile <- opt$summary_bins_file
bin <- as.numeric(opt$bin_number)
outdir <- opt$out_dir

bin_sums <- fread(binfile)
bins <- bin_sums[PHENO == pheno, Bins]


if(bin <= bins){
  files <- list.files(path = file.path(frqdir), pattern = glob2rx(paste0(prefix, "*_", pheno, "_Bin", bin, ".afreq")), full.names = T)
  len <- length(files)
  if(len == 22){
    tmp <- data.table()
    for(file in files){
      frq <- fread(file)
      tmp <- rbind(tmp, frq)
    }
    fwrite(tmp, paste0(outdir, "/", pheno, "_Bin", bin, ".afreq.gz"))
    print(paste0("Finished merging for ", pheno, "_Bin", bin))
  } else{
    print("There are no 22 chromosomes")
  }
} else{
  print("No such bin")
}
