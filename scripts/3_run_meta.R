#!/usr/bin/env Rscript

#################################################################################
#Run GWAS in UKBB between different number of bins for different phenotypes  ####  
#################################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--gwasdir"), type = "character", default = NULL, help = "Full path to the directory of .linear GWAS file for each phenotype per bin"),
  make_option(c("--outdir"), type = "character", default = NULL, help = "Full path to the directory of meta-analysis output for each phenotype per bin"),
  make_option(c("--scriptdir"), type = "character", default = NULL, help = "Full path to the directory of meta-analysis script for each phenotype per bin"),
  make_option(c("--pheno"), type = "character", default = NULL, help = "Phenotype name to run .afreq"),
  make_option(c("--summary_bins_file"), type = "character", default = NULL, help = "Full path to output file summarising number of splitted bins for all phenotypes"),
  make_option(c("--bin_number"), type = "character", default = NULL, help = "The No. of bin to merge .afreq outputs")
)

opt = parse_args(OptionParser(option_list=option_list))

gwasdir <- opt$gwasdir
outdir <- opt$outdir
scriptdir <- opt$scriptdir
pheno <- opt$pheno
bin <- as.numeric(opt$bin_number)
binfile <- opt$summary_bins_file

bin_sums <- fread(binfile)
bins <- bin_sums[PHENO == pheno, Bins]


if(bin >=2 & bin <= bins){
  system(paste0("cat ", scriptdir, "/metal-basic.txt >> ", scriptdir, "/", pheno, "_Bin1toBin", bin, ".sh"))
  for(j in  1:bin){
    if(j <= bin){
      system(paste0("sed -i '$ a PROCESS ", gwasdir, "/", pheno, "_Bin", j, ".glm.linear.gz' ", scriptdir, "/", pheno, "_Bin1toBin", bin, ".sh"))
    }
  }
  system(paste0("sed -i '$ a OUTFILE ", outdir, "/", pheno, "_Bin1toBin", bin, "_ .TBL'  ", scriptdir, "/", pheno, "_Bin1toBin", bin, ".sh"))
  system(paste0("sed -i '$ a ANALYZE HETEROGENEITY'  ", scriptdir, "/", pheno, "_Bin1toBin", bin, ".sh"))
  system(paste0("sed -i '$ a CLEAR'  ", scriptdir, "/", pheno, "_Bin1toBin", bin, ".sh"))
  
  system(paste0("metal ", scriptdir, "/", pheno, "_Bin1toBin", bin, ".sh"))
  out <- fread(paste0(outdir, "/", pheno, "_Bin1toBin", bin, "_1.TBL"))
  out[,Allele1 := toupper(Allele1)]
  out[,Allele2 := toupper(Allele2)]
  fwrite(out, file = paste0(outdir, "/", pheno, "_Bin1toBin", bin, "_1.TBL.gz"), sep = "\t")
  system(paste0("rm ", outdir, "/", pheno, "_Bin1toBin", bin, "_1.TBL"))
  system(paste0("rm ", outdir, "/", pheno, "_Bin1toBin", bin, "_1.TBL.info"))
} else{
  print("Bin number is not valid!")
}


