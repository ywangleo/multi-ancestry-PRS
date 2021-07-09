##update phenofile IIDs
phenofile="/scratch/90days/uqywan67/multi-acestry-PRS/phenotypes/UKB_phenos_ALL17.txt"

ids <- fread("/scratch/90days/uqywan67/multi-acestry-PRS/phenotypes/ukb_version_idlist.txt")
phes <- fread(phenofile)
phes$eid <- ids[match(phes$eid, ids$BROAD),]$PCTG
names(phes)[1] <- "IID"
fwrite(phes, file = "/scratch/90days/uqywan67/multi-acestry-PRS/phenotypes/UKB_phenos_ALL17_updateIDs.txt", sep = "\t", na = NA)

##randomly sample 5K individuals as target population
phenofile="/scratch/90days/uqywan67/multi-acestry-PRS/phenotypes/UKB_phenos_ALL17_updateIDs.txt"
eurfile="/scratch/90days/uqywan67/multi-acestry-PRS/phenotypes/ukb31063.neale_gwas_covariates.both_sexes_remove_withdrawn_updateIDs.tsv"
outf="/scratch/90days/uqywan67/multi-acestry-PRS/bins/ukb_eur_ran5k.idlist"

library(data.table)
phes <- fread(phenofile)
eurs <- fread(eurfile)
phes1 <- phes[IID %in% eurs$s] ##361144
phes1 <- na.omit(phes1) ##325740

set.seed(1234)
ran5k <- phes1[sample(nrow(phes1), 5000), .(IID, IID)]
fwrite(ran5k, file = outf, sep = "\t", col.names = F)




