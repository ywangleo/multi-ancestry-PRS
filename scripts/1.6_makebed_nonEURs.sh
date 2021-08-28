wkdir="/afm01/UQ/Q2909/v3All_impQC"
grmdir="/scratch/90days/uqywan67/multi-ancestry-PRS/phenotypes/unrel"
outdir="/scratch/60days/uqywan67/ukb_nonEURs"

pops="AMR CSA MID EAS AFR"

for pop in ${pops};do
qsubshcom "plink2 --bed $wkdir/ukbAll_imp_chr{TASK_ID}_v3_impQC.bed --bim $wkdir/ukbAll_imp_chr{TASK_ID}_v3_impQC.bim --fam $wkdir/ukbAll_imp_chr8_v3_impQC.fam --maf 0.01  --keep ${grmdir}/${pop}_unrel_updateIDs.pcs.txt --out $outdir/ukb_${pop}_unrel_qcd_chr{TASK_ID} --make-bed --threads 4" 4 60g plink-${pop} 24:00:00 "-array=1-22"
done
