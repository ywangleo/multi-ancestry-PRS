cd /humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/scripts


root="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations"



threads=1
ld_win=500
ld_r2=0.1
pval1=1
pval2=1
p_name="P-value"
snpfield="MarkerName"
threads=4

addbin=${1}
M=${2}
h2=${3}
irep=${4}

pops="AFR EAS EUR"


for pop in ${pops};do


outf1=${root}/clump/single_pop/causIncl_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pop}_Bin1toBin${addbin}.snplist

if [ -f "$outf1" ]; then

echo "output exist"

else

~/plink --bfile /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pop}_qcd --threads ${threads} \
--clump-snp-field ${snpfield} -clump-field ${p_name}  --extract /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_pops_shared.snplist \
--keep /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pop}_10K_holdout.idlist  \
--clump ${root}/meta/causIncl_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pop}_Bin1toBin${addbin}_1.TBL.gz \
--clump-kb ${ld_win} --clump-r2 ${ld_r2}  --clump-p1 ${pval1}  --clump-p2 ${pval2} \
--out ${root}/clump/single_pop/causIncl_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pop}_Bin1toBin${addbin}

if [ -f "${root}/clump/single_pop/causIncl_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pop}_Bin1toBin${addbin}.clumped" ]; then
awk '{print $3}' ${root}/clump/single_pop/causIncl_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pop}_Bin1toBin${addbin}.clumped > ${root}/clump/single_pop/causIncl_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pop}_Bin1toBin${addbin}.snplist

rm ${root}/clump/single_pop/causIncl_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pop}_Bin1toBin${addbin}.clumped
else
echo "output clumped file1 didn't exist"
fi

fi


done




