#!/bin/bash

################################################################################
# Please fill in the below variables
################################################################################
bfile_prefix=""
phenodir=""
pheno=""
bin_number=""
n_threads=1 ##change the number if you can run multiple threads
binfile=""
out_prefix=""


Rscript --slave GWAS_customized.R \
--bfile_prefix ${bfile_prefix} \
--phenodir ${phenodir} \
--pheno ${pheno} \
--bin_number ${bin_number} \
--n_threads ${n_threads} \
--summary_bins_file ${binfile} \
--out_prefix ${out_prefix}
