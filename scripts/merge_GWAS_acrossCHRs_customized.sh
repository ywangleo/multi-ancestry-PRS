gwasdir=""
out_prefix=""
pheno=""
binfile=""
outdir=""
bin=""

Rscript merge_GWAS_acrossCHRs_customized.R \
--gwasdir $gwasdir \
--out_prefix ${out_prefix} \
--pheno ${pheno} \
--summary_bins_file ${binfile} \
--out_dir ${outdir} --bin_number ${bin}
