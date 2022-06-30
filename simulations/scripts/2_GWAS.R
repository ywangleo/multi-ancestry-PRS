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
    make_option(c("--pheno"), type = "character", default = NULL, help = "Full path and full name to  phenotype file"),
      make_option(c("--binfile"), type = "character", default = NULL, help = "The full path and file name of bins to run GWAS"),
        make_option(c("--extract"), type = "character", default = NULL, help = "The full path and file name to variants extracted for running GWAS"),
	  make_option(c("--exclude"), type = "character", default = NULL, help = "The full path and file name to the causal variants to be excluded from running GWAS"),
	    make_option(c("--n_threads"), type = "character", default = 1, help = "Number of threads to run PLINK2"),
	      make_option(c("--out_prefix"), type = "character", default = NULL, help = "Prefix with full path to the output file of GWAS results for each phenotype per bin")
	      )

	      opt = parse_args(OptionParser(option_list=option_list))

	      bfile_prefix <- opt$bfile_prefix
	      pheno <- opt$pheno
	      n_threads <- opt$n_threads
	      binfile <- opt$binfile
	      out_prefix <- opt$out_prefix
	      extract <- opt$extract
	      exclude <- opt$exclude

	      if(0 <= 1){
	        system(paste0("~/plink2 --bfile ", bfile_prefix, " --extract ", extract, " --exclude ", exclude, " --pheno ", pheno, " --keep ", binfile, " --ci 0.95 --glm cols=chrom,pos,ref,alt,a1freq,beta,se,ci,tz,p,nobs omit-ref allow-no-covars  --freq --threads ", n_threads, " --out ", out_prefix))
		} else{
		  print("No such bin file")
		  }

