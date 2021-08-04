#!/usr/bin/env Rscript

##########################################
####Run LD clumping                   ####
##########################################

library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--bfile"), type = "character", default = NULL, help = "Full path and prefix to plink bfile as LD reference"),
  make_option(c("--keep_ids"), type = "character", default = NULL, help = "Full path and file name to the file including IDs (FID, IID) for LD reference"),
  make_option(c("--threads "), type = "character", default = 1, help = "Number of threads used"),
  make_option(c("--snpfield"), type = "character", default = "SNP", help = "Marker column name for clumping"),
  make_option(c("--p_name "), type = "character", default = 1, help = "P-value column name for clumping"),
  make_option(c("--extract_snps"), type = "character", default = NULL, help = "SNP list to limit the SNPs"),
  make_option(c("--clump_file"), type = "character", default = NULL, help = "Full path and file name to the input file for clump"),
  make_option(c("--ld_win"), type = "character", default = 500, help = "LD window in Kb for running LD clumping"),
  make_option(c("--ld_r2"), type = "character", default = 0.1, help = "LD r2 for running LD clumping"),
  make_option(c("--pval1"), type = "character", default = 1, help = "The threadshold for --clump-p1 for running LD clumping"),
  make_option(c("--pval2"), type = "character", default = 1, help = "The threadshold for --clump-p2 for running LD clumping"),
  make_option(c("--chr"), type = "character", default = NULL, help = "The threadshold for --clump-p2 for running LD clumping"),
  make_option(c("--out_file"), type = "character", default = NULL, help = "Full path and file name for the clumped output file")
)

opt = parse_args(OptionParser(option_list=option_list))

bfile <- opt$bfile
ids <- opt$keep_ids 
threads <- opt$threads
snpfield <- opt$snpfield
p_name <- opt$p_name
extract_snps <- opt$extract_snps
clump_file <- opt$clump_file
ld_win <- opt$ld_win
ld_r2 <- opt$ld_r2
pval1 <- opt$pval1
pval2 <- opt$pval2
chr <- opt$chr
out_file <- opt$out_file

if(extract_snps == "NULL") {
  if(ids == "NULL"){
    system(paste0("plink --bfile ", bfile, " --threads ", threads, " --clump-snp-field ", snpfield, " --clump-field ", p_name, " --clump ", clump_file, " --clump-kb ", ld_win, " --clump-r2 ", ld_r2, " --clump-p1 ", pval1, " --clump-p2 ", pval2, " --out ", out_file))
  } else{
    system(paste0("plink --bfile ", bfile, " --threads ", threads, " --clump-snp-field ", snpfield, " --clump-field ", p_name, " --keep ", ids, " --clump ", clump_file, " --clump-kb ", ld_win, " --clump-r2 ", ld_r2, " --clump-p1 ", pval1, " --clump-p2 ", pval2, " --out ", out_file))
  }
} else{
  if(ids == "NULL"){
    system(paste0("plink --bfile ", bfile, " --threads ", threads, " --clump-snp-field ", snpfield, " --clump-field ", p_name, " --extract ", extract_snps, " --clump ", clump_file, " --clump-kb ", ld_win, " --clump-r2 ", ld_r2, " --clump-p1 ", pval1, " --clump-p2 ", pval2, " --out ", out_file))
  } else{
    system(paste0("plink --bfile ", bfile, " --threads ", threads, " --clump-snp-field ", snpfield, " --clump-field ", p_name, " --keep ", ids, " --extract ", extract_snps, " --clump ", clump_file, " --clump-kb ", ld_win, " --clump-r2 ", ld_r2, " --clump-p1 ", pval1, " --clump-p2 ", pval2, " --out ", out_file))
  }
}


system(paste0("awk '{print $3}' ", out_file, ".clumped >> ", out_file, ".snplist"))
system(paste0("rm ", out_file, ".clumped"))
system(paste0("rm ", out_file, ".log"))

