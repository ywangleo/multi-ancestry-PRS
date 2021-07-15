gwasdir=""
out_prefix=""
pheno=""
binfile=""
als_list=""
outdir=""
bin=""

Rscript merge_GWAS_acrossCHRs_customized.R \
--gwasdir $gwasdir \
--out_prefix ${out_prefix} \
--pheno ${pheno} \
--summary_bins_file ${binfile} \
--als_list ${als_list} \
--out_dir ${outdir} --bin_number ${bin}
