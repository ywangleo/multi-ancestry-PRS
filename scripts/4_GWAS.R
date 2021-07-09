library(data.table)
genodir="/scratch/90days/uqywan67/multi-acestry-PRS/data/"
phenodir="/scratch/90days/uqywan67/multi-acestry-PRS/bins/"
outdir="/scratch/90days/uqywan67/multi-acestry-PRS/gwas/chrs/"
binfile="/scratch/90days/uqywan67/multi-acestry-PRS/bins/pheno_bins_summary.txt"

phenames <- c("height", "bmi", "sbp", "dbp", "wbc", "monocyte", "neutrophil",
              "eosinophil", "basophil", "lymphocyte", "rbc", "mch", "mcv",
              "mchc", "hb", "ht", "plt")

args <- commandArgs(trailingOnly = T)

pheno <- phenames[as.numeric(args[1])]
bin <- as.numeric(args[2])
#chr <- args[3]

bin_sums <- fread(binfile)
bins <- bin_sums[PHENO == pheno, Bins]

if(bin <= bins){
  for(chr in 1:22){
  system(paste0("plink2 --bfile ", genodir, "ukb_eurs_qcs_chr", chr, " --pheno ", phenodir, pheno, "_Bin", bin, ".txt --ci 0.95 --linear  --pheno-name ", pheno, " --threads 4 --out ", outdir, "ukb_eurs_", pheno, "_Bin", bin, "_chr", chr))
  }
} else{
  print("Quit")
}
