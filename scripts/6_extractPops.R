
library(data.table)

setwd("/scratch/90days/uqywan67/multi-ancestry-PRS/phenotypes/unrel")
pops <- c("EUR", "AMR", "CSA", "MID", "EAS", "AFR")

ids <- fread("../ukb_version_idlist.txt")

for(pop in pops){
  dat <- fread(paste0(pop, "_unrel.scores.txt"))
  out <- fread("../ukb31063.withdrawn_samples.txt")
  dat <- dat[!s %in% out$s]
  dat$FID <- ids[match(dat$s, ids$BROAD), "PCTG"]
  dat1 <- dat[,c("FID", "FID", paste0("PC", 1:20))]
  names(dat1)[2] <- "IID"
  fwrite(dat1, file = paste0(pop, "_unreal_updateIDs.pcs.txt"), sep = "\t", col.names = T)
}


#cat *updateIDs.* >> ukbb_unrel_pcs.txt
#awk '{print $1,$2}' ukbb_unrel_pcs.txt >> ukbb_unrel.ids
