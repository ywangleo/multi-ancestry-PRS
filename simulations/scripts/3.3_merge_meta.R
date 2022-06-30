setwd("/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/meta")
library(data.table)


args <- commandArgs(trailingOnly = T)
Ms <- c(100, 500, 1000)
h2s <- c(0.03, 0.05)
pops <- c("EUR", "EAS", "AFR")

M <- args[1]
h2 <- args[2]
pop <-args[3]
basebin <- args[4]

outf <- paste0("causIncl_caus", M, "-rep1-h2_", h2, "-S1_-1-", pop, "_Bin1toBin", basebin, "_1.TBL.gz")

if(!file.exists(outf)){
  gwas1 <- fread(paste0("caus", M, "-rep1-h2_", h2, "-S1_-1-", pop, "_Bin1toBin", basebin, "_1.TBL.gz"))
    gwas2 <- fread(paste0("onlyCaus_caus", M, "-rep1-h2_", h2, "-S1_-1-", pop, "_Bin1toBin", basebin, "_1.TBL.gz"))
      gwas <- rbind(gwas1, gwas2)
        
	  fwrite(gwas, file = outf, sep = "\t")

	    if(file.exists(outf) & nrow(gwas) == 87938){
	        #system(paste0("rm caus", M, "-rep1-h2_", h2, "-S1_-1-", pop, "_Bin1toBin", basebin, "_1.TBL.gz"))
	#	    system(paste0("rm onlyCaus_caus", M, "-rep1-h2_", h2, "-S1_-1-", pop, "_Bin1toBin", basebin, "_1.TBL.gz"))
		      }
	  }


