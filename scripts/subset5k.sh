#!/bin/bash

################################################################################
# Please fill in the below variables
################################################################################
phenofile="" 
rel05_list=""
out_file=""


Rscript --slave subset5k.R \
--phenofile ${phenofile} \
--rel05_list ${rel05_list} \
--holdout_file ${out_file} 
