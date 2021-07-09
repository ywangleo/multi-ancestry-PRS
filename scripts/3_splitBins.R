
##randomly split into bins with 5K for different phenotypes
phenofile="/scratch/90days/uqywan67/multi-acestry-PRS/phenotypes/UKB_phenos_ALL17_updateIDs.txt"
eurfile="/scratch/90days/uqywan67/multi-acestry-PRS/phenotypes/ukb31063.neale_gwas_covariates.both_sexes_remove_withdrawn_updateIDs.tsv"
outf="/scratch/90days/uqywan67/multi-acestry-PRS/bins/ukb_eur_ran5k.idlist"
hold_out="/scratch/90days/uqywan67/multi-acestry-PRS/bins/ukb_eur_ran5k.idlist"

phenames <- c("height", "bmi", "sbp", "dbp", "wbc", "monocyte", "neutrophil", 
              "eosinophil", "basophil", "lymphocyte", "rbc", "mch", "mcv", 
              "mchc", "hb", "ht", "plt")

library(data.table)
phes <- fread(phenofile)
eurs <- fread(eurfile)
phes1 <- phes[IID %in% eurs$s] ##361144
holdout <- fread(hold_out, header = F)
phes1 <- phes1[!IID %in% holdout$V1]

split_data_table <- function(x, no_rows_per_frame, prefix_to_store){
  
  split_vec <- seq(1, nrow(x), no_rows_per_frame)
  
  for (i in 1:(length(split_vec) - 1)) {
    split_cut <- split_vec[i]
    sample <- x[split_cut : (split_cut + (no_rows_per_frame-1))]
    #fwrite(sample, paste(path_to_store, "sample_until_", (split_cut+(no_rows_per_frame-1)), ".csv", sep = ""))
    fwrite(sample, paste0(prefix_to_store,  i, ".txt"), sep = "\t")
    
  }
}

sums <- data.table()
for(PHENO in phenames){
  names <- c("IID", "IID", PHENO)
  tmp <- phes1[,..names]
  tmp1 <- na.omit(tmp)
  Bins <- floor(nrow(tmp1)/5000)
  counts <- data.table(PHENO, Bins)
  sums <- rbind(sums, counts)
  
  names(tmp1) <- c("FID", "IID", PHENO)
  set.seed(1234)
  tmp2 <- tmp1[sample(nrow(tmp1), nrow(tmp1))]
  #tmp3 <- tmp2[,c("FID", "IID")]
  split_data_table(x = tmp2, no_rows_per_frame = 5000, 
                   prefix_to_store = paste0("/scratch/90days/uqywan67/multi-acestry-PRS/bins/", PHENO, "_Bin"))
}

fwrite(sums, file = "/scratch/90days/uqywan67/multi-acestry-PRS/bins/pheno_bins_summary.txt", sep = "\t")

