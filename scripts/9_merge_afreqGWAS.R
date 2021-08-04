#!/usr/bin/env Rscript

###########################################################################
##merge frequncy to GWAS sumstats in each bin for different phenotypes ####  
###########################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--frqdir"), type = "character", default = NULL, help = "Full path to the directory of .afreq file for each phenotype per bin"),
  make_option(c("--gwasdir"), type = "character", default = NULL, help = "Full path to the directory of .linear GWAS file for each phenotype per bin"),
  make_option(c("--pheno"), type = "character", default = NULL, help = "Phenotype name to run .afreq"),
  make_option(c("--summary_bins_file"), type = "character", default = NULL, help = "Full path to output file summarising number of splitted bins for all phenotypes"),
  make_option(c("--als_list"), type = "character", default = NULL, help = "Full path and file name to the file listing SNP A1 A2 based on .bim plink file from the whole Biobank, no headers specified"),
  make_option(c("--bin_number"), type = "character", default = NULL, help = "The No. of bin to merge .afreq outputs")
)

opt = parse_args(OptionParser(option_list=option_list))

frqdir <- opt$frqdir
gwasdir <- opt$gwasdir
pheno <- opt$pheno
bin <- as.numeric(opt$bin_number)
binfile <- opt$summary_bins_file
als.list <- opt$als_list
als <- fread(als.list, header = F)

bin_sums <- fread(binfile)
bins <- bin_sums[PHENO == pheno, Bins]

###We will report BETA/AF based on ALT allele as PLINK is based on A1 allele, and sometimes A1/ALT is not consistent
if(bin <= bins){
  frq <- fread(paste0(frqdir, "/", pheno, "_Bin", bin, ".afreq.gz"))
  gwas <- fread(paste0(gwasdir, "/", pheno, "_Bin", bin, ".glm.linear.gz"))
  gwas[,BETA := ifelse(ALT == A1, BETA, BETA * -1)]
  
  com_snp <- intersect(frq$ID, gwas$ID)
  frq_1 <- frq[ID %in% com_snp]
  gwas_1 <- gwas[ID %in% com_snp]
  
  if(gwas_1[REF == frq_1$REF & ALT == frq_1$ALT, .N] == nrow(gwas_1)){
    gwas_1[,A1_FREQ := frq[match(gwas_1$ID, frq$ID), ALT_FREQS]]
    
    als_1 <- als[match(gwas_1$ID, als$V1),]
    gwas_1[,a1 := als_1$V2]
    gwas_1[,a2 := als_1$V3]
    
    gwas_1[,BETA := ifelse(ALT == a1, BETA, -1 * BETA)]
    gwas_1[,A1_FREQ := ifelse(ALT == a1, A1_FREQ, 1 - A1_FREQ)]
    
    fwrite(gwas_1, paste0(gwasdir, "/", pheno, "_Bin", bin, ".glm.linear.gz"))
  } else {
    same <- gwas_1[REF == frq_1$REF & ALT == frq_1$ALT]
    same[,A1_FREQ := frq_1[match(same$ID, frq_1$ID), ALT_FREQS]]
    
    diff <- gwas_1[REF == frq_1$ALT & ALT == frq_1$REF]
    diff[,A1_FREQ := 1 - frq_1[match(diff$ID, frq_1$ID),  ALT_FREQS]]
    
    gwas_2 <- rbind(same, diff)
    
    als_1 <- als[match(gwas_2$ID, als$V1),]
    gwas_2[,a1 := als_1$V2]
    gwas_2[,a2 := als_1$V3]
    
    gwas_2[,BETA := ifelse(ALT == a1, BETA, -1 * BETA)]
    gwas_2[,A1_FREQ := ifelse(ALT == a1, A1_FREQ, 1 - A1_FREQ)]
    fwrite(gwas_2, paste0(gwasdir, "/", pheno, "_Bin", bin, ".glm.linear.gz"))
  }
} else{
  print("No such bin file")
}







