#!/usr/bin/env Rscript

#################################################################################
#Run GWAS in UKBB between different number of bins for different phenotypes  ####  
#################################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments

#########parsing argument options########
option_list <- list(
  make_option(c("--gwasdir_base"), type = "character", default = NULL, help = "Full path to the directory of baseGWAS"),
    make_option(c("--gwasdir_add"), type = "character", default = NULL, help = "Full path to the directory of addGWAS"),
      make_option(c("--outdir"), type = "character", default = NULL, help = "Full path to the directory of meta-analysis output for each phenotype per bin"),
        make_option(c("--scriptdir"), type = "character", default = NULL, help = "Full path to the directory of meta-analysis script for each phenotype per bin"),
	  make_option(c("--rep"), type = "character", default = NULL, help = "number of replicate"),
	    make_option(c("--Ms"), type = "character", default = NULL, help = "number of causal variants"),
	      make_option(c("--h2"), type = "character", default = NULL, help = "heritability"),
	      #  make_option(c("--Spara2"), type = "character", default = NULL, help = "negative selection"),
	        make_option(c("--pop_base"), type = "character", default = NULL, help = "baseGWAS Pop name"),
		  make_option(c("--pop_add"), type = "character", default = NULL, help = "addGWAS Pop name"),
		    make_option(c("--basebin"), type = "character", default = NULL, help = "The No. of basebin"),
		    make_option(c("--addbins"), type = "character", default = NULL, help = "The total No. of addbins")
		    )

		    opt = parse_args(OptionParser(option_list=option_list))

		    gwasdir_base <- opt$gwasdir_base
		    gwasdir_add <- opt$gwasdir_add
		    outdir <- opt$outdir
		    scriptdir <- opt$scriptdir
		    rep <- as.numeric(opt$rep)
		    M <- as.numeric(opt$Ms)
		    h2 <- as.numeric(opt$h2)
		    #S <- opt$Spara2
		    pop_base <- opt$pop_base
		    pop_add <- opt$pop_add
		    basebin <- as.numeric(opt$basebin)
		    addbins <- as.numeric(opt$addbins)

		    S=-1 ##note negative number as arguments resulting in errors

		    if (0 < 1){
		      for(addbin in 1:addbins){
		          if(addbin == 1){
			        if(!file.exists(paste0(gwasdir_add, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "_Bin1toBin1_1.TBL.gz"))){
				        gwas <- fread(paste0(gwasdir_add, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "_Bin1.PHENO1.glm.linear"))
					        headers <- c("#CHROM", "POS", "ID", "REF", "ALT", "A1", "A1_FREQ", "OBS_CT",
						                     "BETA", "SE", "P")
								             gwas1 <- gwas[,..headers]
									             
										             names(gwas1) <- c("CHROM", "POS", "MarkerName", "Allele2", "Allele1", "A1", "Freq1", "TOTALSAMPLESIZE", "Effect", "StdErr", "P-value")
											             fwrite(gwas1, file = paste0(gwasdir_add, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "_Bin1toBin1_1.TBL.gz"), col.names = T, sep = "\t")
												             
													             GWAS <- fread(paste0(gwasdir_add, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_add, "_Bin1.PHENO1.glm.linear"))
														             headers <- c("#CHROM", "POS", "ID", "REF", "ALT", "A1", "A1_FREQ", "OBS_CT",
															                          "BETA", "SE", "P")
																		          GWAS1 <- GWAS[,..headers]
																			          
																				          names(GWAS1) <- c("CHROM", "POS", "MarkerName", "Allele2", "Allele1", "A1", "Freq1", "TOTALSAMPLESIZE", "Effect", "StdErr", "P-value")
																					          fwrite(GWAS1, file = paste0(gwasdir_add, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_add, "_Bin1toBin1_1.TBL.gz"), col.names = T, sep = "\t")
																						          
																							        }
																								    }
																								        
																									    if(!file.exists(paste0(scriptdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, ".sh"))){
																									          system(paste0("cat ", scriptdir, "/metal-basic2.txt >> ", scriptdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, ".sh"))
																										        system(paste0("sed -i '$ a PROCESS ", gwasdir_base, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base,  "_Bin1toBin", basebin, "_1.TBL.gz' ", scriptdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, ".sh"))
																											      system(paste0("sed -i '$ a PROCESS ", gwasdir_add, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_add,  "_Bin1toBin", addbin, "_1.TBL.gz' ", scriptdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, ".sh"))
																											            
																												          system(paste0("sed -i '$ a OUTFILE ", outdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, "_ .TBL'  ", scriptdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, ".sh"))
																													        system(paste0("sed -i '$ a ANALYZE HETEROGENEITY'  ", scriptdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, ".sh"))
																														      system(paste0("sed -i '$ a CLEAR'  ", scriptdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, ".sh"))
																														          }
																															      
																															          system(paste0("/home/unix/yiwang/generic-metal/metal ", scriptdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, ".sh"))
																																      if(file.exists(paste0(outdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, "_1.TBL"))){
																																            out <- fread(paste0(outdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, "_1.TBL"))
																																	          out[,Allele1 := toupper(Allele1)]
																																		        out[,Allele2 := toupper(Allele2)]
																																			      fwrite(out, file = paste0(outdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, "_1.TBL.gz"), sep = "\t")
																																			          } else{
																																				        print("No output file!")
																																					    }
																																					        
																																						    if(file.exists(paste0(outdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, "_1.TBL.gz"))){
																																						          system(paste0("rm ", outdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, "_1.TBL"))
																																							        system(paste0("rm ", outdir, "/caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "Add", pop_add, "_baseBin", basebin, "addBin", addbin, "_1.TBL.info"))
																																								    } else{
																																								          print("failed compress")
																																									      }
																																									        }
																																										}



