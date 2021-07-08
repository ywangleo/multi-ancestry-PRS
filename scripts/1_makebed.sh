

wkdir="/afm01/UQ/Q2909/v3All_impQC"
outdir="/scratch/90days/uqywan67/data"

chr=${TASK_ID}

plink --bed $wkdir/ukbAll_imp_chr${chr}_v3_impQC.bed --bim $wkdir/ukbAll_imp_chr${chr}_v3_impQC.bim --fam $wkdir/ukbAll_imp_chr8_v3_impQC.fam --maf 0.01 --geno 0.05 --mind 0.1 --keep $outdir/ukb_eur.ids --out $outdir/ukb_eurs_qcs_chr${chr} --make-bed
