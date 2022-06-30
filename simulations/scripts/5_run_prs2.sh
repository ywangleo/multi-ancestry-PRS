cd /humgen/atgu1/fs03/yiwang/hapgen2/simulations/scripts


root="/humgen/atgu1/fs03/yiwang/hapgen2/simulations"

pop_base="EUR"
basebins=$(seq 4 4 52)
addbins=52

pop=$1
M=$2
h2=$3
basebin=$4
irep=$5

pops="EUR AFR EAS"

for addbin in $(seq 1 52);do

###using addedPop ad LD reference
if [[ 0 -gt 1 ]]; then

for pp in ${pops};do
tmp=${root}/clump/profiles/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}.S10.sscore

if [ -f "$tmp" ];then
echo "outf exist"
else
~/plink2 --bfile /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pp}_qcd \
--keep /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pp}_10K_holdout.idlist \
--extract ${root}/clump/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.snplist \
--q-score-range range2.txt ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_1.TBL.gz 1 8 header \
--score ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_1.TBL.gz 1 2 6 cols=+scoresums center \
--out ${root}/clump/profiles/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin} --threads 4
fi

done

fi

###using EUR ad LD reference

if [[ 2 -gt 1 ]]; then

for pp in ${pops};do
tmp=${root}/clump/profiles/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldrefEUR.S10.sscore

if [ -f "$tmp" ];then
echo "outf exist"
else
~/plink2 --bfile /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pp}_qcd \
--keep /humgen/atgu1/fs03/yiwang/hapgen2/data/plink_bfiles/1kg_${pp}_10K_holdout.idlist \
--extract ${root}/clump/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldrefEUR.snplist \
--q-score-range range2.txt ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_1.TBL.gz 1 8 header \
--score ${root}/meta/caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_1.TBL.gz 1 2 6 cols=+scoresums center \
--out ${root}/clump/profiles/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldrefEUR --threads 4
fi

done

fi

done


