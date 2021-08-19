
#!/usr/bin/env Rscript

##########################################
####Run PRS based on LD clumping      ####
##########################################

library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--bfile"), type = "character", default = NULL, help = "Full path and prefix to plink bfile as LD reference"),
  make_option(c("--ids"), type = "character", default = NULL, help = "Full path and file name listing the sample ids to be included"),
  make_option(c("--clump_file"), type = "character", default = NULL, help = "Full path and file name to the input file for clump"),
  make_option(c("--extract_snps"), type = "character", default = NULL, help = "SNP list to limit the SNPs"),
  make_option(c("--rangefile"), type = "character", default = NULL, help = "Full path and file name of p-value ranges"),
  make_option(c("--out_file"), type = "character", default = NULL, help = "Full path and file name for the prs output file")
)

opt = parse_args(OptionParser(option_list=option_list))

bfile <- opt$bfile
ids <- opt$ids
clump_file <- opt$clump_file
extract_snps <- opt$extract_snps
rangefile <- opt$rangefile
out_file <- opt$out_file

snps <- fread(extract_snps, header = T)
if(nrow(snps) > 0){
  clump <- fread(clump_file, header = T)[MarkerName %in% snps$SNP][,.(MarkerName, Allele1, Effect, `P-value`)]
  
  fwrite(clump, file = paste0(clump_file, ".tmp"), sep = "\t")
  
  if(ids != "NULL"){
    system(paste0("plink --bfile ", bfile, " --keep ", ids, " --score ", clump_file, ".tmp 1 2 3 sum --extract  ", extract_snps, " --q-score-range ", rangefile, " ", clump_file, ".tmp 1 4 header --out  ", out_file))
  } else{
    system(paste0("plink --bfile ", bfile, " --score ", clump_file, ".tmp 1 2 3 sum --extract  ", extract_snps, " --q-score-range ", rangefile, " ", clump_file, ".tmp 1 4 header --out  ", out_file))
  }
  
  system(paste0("rm ", clump_file, ".tmp"))
} else{
  print("No such SNPs")
}

