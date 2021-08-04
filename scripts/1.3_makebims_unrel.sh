


wkdir="/afm01/UQ/Q2909/v3All_impQC"
outdir="/scratch/90days/uqywan67/multi-ancestry-PRS/phenotypes/unrel/bims"
grmdir="/scratch/90days/uqywan67/multi-ancestry-PRS/phenotypes/unrel"

chr=${TASK_ID}

pops="EUR AMR CSA MID EAS AFR"

for pop in ${pops};do
plink2 --bed $wkdir/ukbAll_imp_chr${chr}_v3_impQC.bed --bim $wkdir/ukbAll_imp_chr${chr}_v3_impQC.bim --fam $wkdir/ukbAll_imp_chr8_v3_impQC.fam --maf 0.01 --keep ${grmdir}/${pop}_unrel_updateIDs.pcs.txt --out $outdir/ukb_${pop}_unrel_qcd2_chr${chr} --make-just-bim --threads 4
done
