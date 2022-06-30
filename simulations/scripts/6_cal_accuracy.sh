prsdir="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/clump/profiles/multi_pops"
phenodir="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/phenos"
outdir="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/clump/outputs/multi_pops"

cd /humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/scripts


pops="EUR AFR EAS"
seqs="1 2 3 4 5 6 7 10"

pop_base="EUR"
basebins=$(seq 4 4 52)
addbins=52

pop=$1
M=$2
h2=$3
basebin=$4
irep=$5
ldref1="EUR"
covs="NULL"
pc_numbers="NULL"
covfile="NULL"
pcfile="NULL"
popfile="NULL"

#for addbin in $(seq 1 52);do
for addbin in {1..1};do

for pp in ${pops};do ## target population

for seq in ${seqs};do

if [[ 2 -gt 1  ]]; then

##using addPop as LD reference 
tmp=${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.S${seq}

if [ -f "$tmp" ];then
echo "output1 exist"
else
Rscript 6_cal_accuracy.R --pop $pp --addpop ${pop} \
--phenofile $phenodir/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}.phen \
--covs ${covs} --pc_numbers ${pc_numbers} --covfile ${covfile} --pcfile ${pcfile} --popfile ${popfile} \
--prsfile $prsdir/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.S${seq}.sscore \
--ldref ${pop} --out ${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.S${seq}
fi

fi



if  [[ 2 -gt 1  ]]; then

##using EUR as LD reference 
tmp=${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${ldref1}.S${seq}

if [ -f "$tmp" ];then
echo "output1 exist"
else
Rscript 6_cal_accuracy.R --pop $pp --addpop ${pop} \
--phenofile $phenodir/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}.phen \
--covs ${covs} --pc_numbers ${pc_numbers} --covfile ${covfile} --pcfile ${pcfile} --popfile ${popfile}  \
--prsfile $prsdir/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${ldref1}.S${seq}.sscore \
--ldref ${ldref1} --out ${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${ldref1}.S${seq}
fi

fi

done

done

done

