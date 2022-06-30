cd /humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/scripts


root="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations"


addbin=${1}
M=${2}
h2=${3}
irep=${4}

pps="AFR EAS EUR"


for pp in ${pps};do

for pop2 in ${pps};do

if [[ $pp != $pop2 ]];then

###using addedpp ad LD reference
if [[ 2 -gt 1 ]]; then
tmp=("`ls ${root}/clump/profiles/single_pop/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}in${pop2}_Bin1toBin${addbin}.S*.sscore | wc -l`")

if [ $tmp == 8 ];then
echo "outf exist"
else
if [ $addbin == 1 ];then
~/plink2 --bfile /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pop2}_qcd \
--keep /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pop2}_10K_holdout.idlist \
--extract ${root}/clump/single_pop/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}.snplist \
--q-score-range range2.txt ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}_1.TBL.gz 3 11 header \
--score ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}_1.TBL.gz 3 5 9 cols=+scoresums center \
--out ${root}/clump/profiles/single_pop/${pp}in${pop2}_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin} --threads 4
else
~/plink2 --bfile /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pop2}_qcd \
--keep /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pop2}_10K_holdout.idlist \
--extract ${root}/clump/single_pop/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}.snplist \
--q-score-range range2.txt ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}_1.TBL.gz 1 8 header \
--score ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}_1.TBL.gz 1 2 6 cols=+scoresums center \
--out ${root}/clump/profiles/single_pop/${pp}in${pop2}_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin} --threads 4
fi

fi

fi
fi

done

done
