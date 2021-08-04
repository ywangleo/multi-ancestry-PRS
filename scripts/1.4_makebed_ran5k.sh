

wkdir="/afm01/UQ/Q2909/v3All_impQC"
outdir="/scratch/90days/uqywan67/multi-ancestry-PRS/data"

chr=${TASK_ID}

plink2 --bfile $outdir/ukb_eurs_qcs_chr${chr} --keep /scratch/90days/uqywan67/multi-ancestry-PRS/bins/ukb_eur_ran5k.idlist --make-bed --out ${outdir}/ukb_eur_ran5k_chr${chr} --threads 4
