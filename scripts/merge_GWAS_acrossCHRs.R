#!/usr/bin/env Rscript

######################################################################################
##Merge GWAS and .afreq across chromosomes in each bin for different phenotypes   ####  
######################################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments


#########parsing argument options########
option_list <- list(
  make_option(c("--gwasdir"), type = "character", default = NULL, help = "Full path to the directory of GWAS .linear and .afreq outputs per chromosome for each phenotype per bin"),
  make_option(c("--out_prefix"), type = "character", default = NULL, help = "Prefix (no need to specify chromosme number) to the output file of GWAS results .linear and .afreq per chromosme for each phenotype per bin, specified in GWAS.sh"),
  make_option(c("--pheno"), type = "character", default = NULL, help = "Phenotype name to run GWAS"),
  make_option(c("--summary_bins_file"), type = "character", default = NULL, help = "Full path to output file summarising number of splitted bins for all phenotypes"),
  make_option(c("--bin_number"), type = "character", default = NULL, help = "The No. of bin to merge GWAS outputs"),
  make_option(c("--als_list"), type = "character", default = NULL, help = "Full path and file name to the file listing SNP A1 A2 based on .bim plink file from the whole Biobank, no headers specified"),
  make_option(c("--out_dir"), type = "character", default = NULL, help = "Full path to the directory of merged GWAS for each phenotype per bin")
)

opt = parse_args(OptionParser(option_list=option_list))

gwasdir <- opt$gwasdir
pheno <- opt$pheno
prefix <- opt$out_prefix
binfile <- opt$summary_bins_file
bin <- as.numeric(opt$bin_number)
als.list <- opt$als_list
outdir <- opt$out_dir

bin_sums <- fread(binfile)
bins <- bin_sums[PHENO == pheno, Bins]

als <- fread(als.list, header = F)

###BETA/AF based on provided a1/a2 alleles from the whole Biobank

if(bin <= bins){
  files <- list.files(path = file.path(gwasdir), pattern = glob2rx(paste0(prefix, "*_", pheno, "_Bin", bin, ".*linear")), full.names = T)
  files1 <- list.files(path = file.path(gwasdir), pattern = glob2rx(paste0(prefix, "*_", pheno, "_Bin", bin, ".*afreq")), full.names = T)
  
  if(length(files) == length(files1) == 22){
    gwas <- data.table()
    frq <- data.table()
    for(i in 1:length(files)){
      file <- files[1]
      file1 <- files1[1]
      tmp <- fread(file)
      tmp1 <- fread(file1)
      gwas <- rbind(gwas, tmp)
      frq <- rbind(frq, tmp1)
    }
    gwas[,BETA := ifelse(ALT == A1, BETA, BETA * -1)]
    gwas[,ALT_FREQ := frq[match(gwas$ID, frq$ID), ALT_FREQS]]
  
    als_1 <- als[match(gwas$ID, als$V1),]
    gwas[,a1 := als_1$V2]
    gwas[,a2 := als_1$V3]
    
    gwas[,BETA := ifelse(ALT == a1, BETA, -1 * BETA)]
    gwas[,A1_FREQ := ifelse(ALT == a1, A1_FREQ, 1 - A1_FREQ)]
    
    fwrite(gwas, paste0(outdir, "/", pheno, "_Bin", bin, ".glm.linear.gz"))
    
    print(paste0("Finished merging for ", pheno, "_Bin", bin))
  } else{
    print("There is no 22 chromosomes")
  }
} else{
  print("No such bin")
}
