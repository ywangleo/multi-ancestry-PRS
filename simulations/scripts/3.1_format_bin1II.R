library(data.table)

gwasdir_add="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/meta"
S="-1"
gwasdir_base="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/gwas"

args <- commandArgs(trailingOnly = T)

M <- args[1]
h2 <- args[2]
pop_base <- args[3]
rep <- args[4]

if(!file.exists(paste0(gwasdir_add, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "_Bin1toBin1_1.TBL.gz"))){
  gwas <- fread(paste0(gwasdir_base, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "_Bin1.PHENO1.glm.linear"))
    headers <- c("#CHROM", "POS", "ID", "REF", "ALT", "A1", "A1_FREQ", "OBS_CT",
                   "BETA", "SE", "P")
		     gwas1 <- gwas[,..headers]
		       
		         names(gwas1) <- c("CHROM", "POS", "MarkerName", "Allele2", "Allele1", "A1", "Freq1", "TOTALSAMPLESIZE", "Effect", "StdErr", "P-value")
			   fwrite(gwas1, file = paste0(gwasdir_add, "/onlyCaus_caus", M, "-rep", rep, "-h2_", h2, "-S1_", S, "-", pop_base, "_Bin1toBin1_1.TBL.gz"), col.names = T, sep = "\t")
			   }
			   
