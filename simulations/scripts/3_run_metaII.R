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
        make_option(c("--rep"), type = "character", default = NULL, help = "number of replicate"),
	  make_option(c("--Ms"), type = "character", default = NULL, help = "number of onlyCaus_causal variants"),
	    make_option(c("--h2"), type = "character", default = NULL, help = "heritability"),
	    #  make_option(c("--Spara2"), type = "character", default = NULL, help = "negative selection"),
	      make_option(c("--pop"), type = "character", default = NULL, help = "Pop name"),
	        make_option(c("--bin_number"), type = "character", default = NULL, help = "The No. of bin")
		)

		opt = parse_args(OptionParser(option_list=option_list))
		print(opt)
		gwasdir <- opt$gwasdir
		outdir <- opt$outdir
		scriptdir <- opt$scriptdir
		rep <- as.numeric(opt$rep)
		M <- as.numeric(opt$Ms)
		h2 <- as.numeric(opt$h2)
		#S <- opt$Spara2
		pop <- opt$pop
		bin <- as.numeric(opt$bin_number)

		S=-1 ##note negative number as arguments resulting in errors

		if(bin >= 2){
		  if(!file.exists(paste0(scriptdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, ".sh"))){
		      system(paste0("cat ", scriptdir, "/metal-basic.txt >> ", scriptdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, ".sh"))
		          for(j in  1:bin){
			        if(j <= bin){
				        system(paste0("sed -i '$ a PROCESS ", gwasdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin", j, ".PHENO1.glm.linear' ", scriptdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, ".sh"))
					      }
					          }
						      system(paste0("sed -i '$ a OUTFILE ", outdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, "_ .TBL'  ", scriptdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, ".sh"))
						          system(paste0("sed -i '$ a ANALYZE HETEROGENEITY'  ", scriptdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, ".sh"))
							      system(paste0("sed -i '$ a CLEAR'  ", scriptdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, ".sh"))
							        }
								  
								    system(paste0("/home/unix/yiwang/generic-metal/metal ", scriptdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, ".sh"))
								      if(file.exists(paste0(outdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, "_1.TBL"))){
								          out <- fread(paste0(outdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, "_1.TBL"))
									      out[,Allele1 := toupper(Allele1)]
									          out[,Allele2 := toupper(Allele2)]
										      fwrite(out, file = paste0(outdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, "_1.TBL.gz"), sep = "\t")
										        }
											  if(file.exists(paste0(outdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, "_1.TBL.gz"))){
											      system(paste0("rm ", outdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, "_1.TBL"))
											          system(paste0("rm ", outdir, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop,  "_Bin1toBin", bin, "_1.TBL.info"))
												    }
												    } else{
												      print("Bin number is not valid!")
												      }


