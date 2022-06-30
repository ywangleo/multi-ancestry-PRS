cd /humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/scripts


root="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations"

pop_base="EUR"
basebins=$(seq 4 4 52)
addbins=52


threads=1
ld_win=500
ld_r2=0.1
pval1=1
pval2=1
p_name="P-value"
snpfield="MarkerName"
threads=1

pop=$1
M=$2
h2=$3
basebin=$4
irep=$5

#for addbin in $(seq 1 52);do
for addbin in {1..1};do

outf1=${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldrefEUR.snplist
outf2=${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.snplist

if [ -f "$outf1" ]; then

echo "EUR output exist"

else
##using 1KG-EUR as LD reference
~/plink --bfile /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_EUR_qcd --threads ${threads} \
--clump-snp-field ${snpfield} -clump-field ${p_name}  --extract /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_pops_shared.snplist \
--keep /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_EUR_10K_holdout.idlist  \
--clump ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_1.TBL.gz \
--clump-kb ${ld_win} --clump-r2 ${ld_r2}  --clump-p1 ${pval1}  --clump-p2 ${pval2} \
--out ${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldrefEUR

if [ -f "${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldrefEUR.clumped" ]; then
awk '{print $3}' ${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldrefEUR.clumped > ${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldrefEUR.snplist

rm ${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldrefEUR.clumped
else
echo "output clumped file1 didn't exist"
fi

fi


if [ -f "$outf2" ]; then

echo "Pop-specific output2 exist"

else
##using pop_add as LD reference
~/plink --bfile /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pop}_qcd --threads ${threads} \
--clump-snp-field ${snpfield} -clump-field ${p_name} --extract /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_pops_shared.snplist \
--keep /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pop}_10K_holdout.idlist  \
--clump ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_1.TBL.gz \
--clump-kb ${ld_win} --clump-r2 ${ld_r2}  --clump-p1 ${pval1}  --clump-p2 ${pval2} \
--out ${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}


if [ -f "${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.clumped" ]; then
awk '{print $3}' ${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.clumped > ${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.snplist
rm ${root}/clump/multi_pops/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.clumped
else
echo "output clumped file2 didn't exist"
fi

fi


done




