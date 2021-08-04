

cd /scratch/90days/uqywan67/multi-ancestry-PRS/data

for i in {2..22};do
echo ukb_eur_ran5k_chr${i} >> merge_5k.list
done


plink --bfile ukb_eur_ran5k_chr1 --merge-list merge_5k.list --make-bed --out ukb_eur_ran5k 
