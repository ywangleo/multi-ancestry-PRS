#!/bin/bash

################################################################################
# Please fill in the below variables
################################################################################
phenofile=""
all_phenos=""
rel05_list=""
holdout=""
binfile=""
outdir=""

Rscript --slave splitBins.R \
--phenofile ${phenofile} \
--all_phenos ${all_phenos} \
--rel05_list ${rel05_list} \
--holdout ${holdout} \
--summary_bins_file ${binfile} \
--outdir ${outdir}
