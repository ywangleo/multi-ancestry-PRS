#!/usr/bin/env Rscript

###################################################################
##randomly split into bins with 5K for different phenotypes    ####  
###################################################################

########load packages needed########
library(data.table)
library(optparse) #for parsing arguments
library(ggplot2)

#########parsing argument options########
option_list <- list(
  make_option(c("--phenofile"), type = "character", default = NULL, help = "Full path to phenotype files with IID included in the headers"),
  make_option(c("--all_phenos"), type = "character", default = NULL, help = "a vector of phenotypes, separated by comma"),
  make_option(c("--rel05_list"), type = "character", default = NULL, help = "Full path to the file listing all unrelated individuals in that specific ancestry (in the order of FID, IID)"),
  make_option(c("--outdir"), type = "character", default = NULL, help = "Full path to the directory of output file storing ids as well as phenotype for each phenotype per bin"),
  make_option(c("--summary_bins_file"), type = "character", default = NULL, help = "Full path to output file summarising number of splitted bins for all phenotypes")
)

opt = parse_args(OptionParser(option_list=option_list))

phenofile <- opt$phenofile
phenames <- opt$all_phenos
phenames1 <- strsplit(phenames,",")[[1]]
rel05 <- opt$rel05_list
outdir <- opt$outdir
binfile <- opt$summary_bins_file

###read input files
phes <- fread(phenofile)
if(rel05 != "NULL"){
  ids <- fread(rel05, header = F)
  alls <- phes[IID %in% ids$V2]
} else{
  alls <- phes
}

###function used
split_data_table <- function(x, no_rows_per_frame){
  split_vec <- seq(1, nrow(x), no_rows_per_frame)
  ids <- data.table()
  for (i in 1:(length(split_vec) - 1)) {
    split_cut <- split_vec[i]
    samples <- x[split_cut : (split_cut + (no_rows_per_frame-1))]
    
    sample_ids <- data.table(samples, i)
    ids <- rbind(ids, sample_ids)
  }
  return(ids)
}


###split bins
sums_bin <- data.table() ##summary the number of bins for each phenotype
for(PHENO in phenames1){
  nms2 <- c("IID", "IID", "sex", "age", PHENO)
  tmp <- alls[,..nms2]
  tmp1 <- na.omit(tmp)
  Bins <- floor(nrow(tmp1)/5000)
  counts <- data.table(PHENO, Bins)
  sums_bin <- rbind(sums_bin, counts)
  
  res <- data.table() ##split age and SES based on quartiles, with a total of 2 * 4 = 8 bins
  for(g1 in 1:2){
    dat <- tmp1[sex == g1]
    dat$age_group <- "NA"
    dat$age_group <- as.numeric(cut_number(dat$age, 4))
    res <- rbind(res, dat)
  }
  
  cols <- c("sex", "age_group")
  res$Group <- apply( res[,..cols ] , 1 , paste , collapse = "-" ) ##32 Groups
  
  
  ##the Count and sampled N in each of the 32 Groups
  sums <- res[,.N, by ="Group"]
  sums[,N_raw := N/nrow(res) * 5000]
  sums[,N_sub := round(N/nrow(res) * 5000)]
  sums <- sums[order(N_sub)]
  
  diffs <- sum(sums$N_sub) - 5000
  if(diffs < 0){
    sums[(nrow(sums) - abs(diffs) + 1):nrow(sums), N_sub := N_sub + 1]
  } else if (diffs > 0) {
    sums[1:abs(diffs), N_sub := N_sub - 1]
  } else {
    print(paste0("Sum is now ", sum(sums$N_sub)))
  }
  
  ### split each Group into number of Bins
  outs <- data.table()
  for(g in sums$Group){
    N <- sums[Group == g, N_sub]
    
    res1 <- res[Group == g]
    
    set.seed(1234)
    res2 <- res1[sample(nrow(res1), nrow(res1))]
    tmp_ids <- split_data_table(x = res2, no_rows_per_frame = N)
    outs <- rbind(outs, tmp_ids)
  }
  
  ##write the output for each Bin
  for(bin in 1:Bins){
    ns <- c("IID", "IID", PHENO)
    out <- outs[i == bin][,..ns]
    names(out) <- c("FID", "IID", PHENO)
    fwrite(out,  paste0(outdir, "/matched_", PHENO, "_Bin", bin, ".txt"), sep = "\t")
  }
}

fwrite(sums_bin, file = binfile, sep = "\t")

