gwasdir=""
out_prefix=""
pheno=""
binfile=""
outdir=""
bin=""

Rscript 5_merge_GWAS_acrossCHRs.R \
--gwasdir $gwasdir \
--out_prefix ${out_prefix} \
--pheno ${pheno} \
--summary_bins_file ${binfile} \
--out_dir ${outdir} --bin_number ${bin}
