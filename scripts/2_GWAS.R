library(data.table)
genodir=" "
phenodir= " "
outdir=" "
binfile= " "
covfile=" "

phenames <- c("height", "bmi", "sbp", "dbp", "wbc", "monocyte", "neutrophil",
              "eosinophil", "basophil", "lymphocyte", "rbc", "mch", "mcv",
              "mchc", "hb", "ht", "plt")

args <- commandArgs(trailingOnly = T)

pheno <- phenames[as.numeric(args[1])]
bin <- as.numeric(args[2])

bin_sums <- fread(binfile)
bins <- bin_sums[PHENO == pheno, Bins]

if(bin <= bins){
  for(chr in 1:22){
    system(paste0("plink2 --bfile ", genodir, "ukb_eurs_qcs_chr", chr, " --pheno ", phenodir, pheno, "_Bin", bin, ".txt --ci 0.95 --glm cols=chrom,pos,ref,alt,a1freq,beta,se,ci,tz,p,nobs hide-covar  no-x-sex  --vif 1000000 --covar ", covfile, " --covar-variance-standardize --freq --pheno-name ", pheno, " --threads 1 --out ", outdir, "ukb_eurs_", pheno, "_Bin", bin, "_chr", chr))
  }
} else{
  print("Quit")
}


