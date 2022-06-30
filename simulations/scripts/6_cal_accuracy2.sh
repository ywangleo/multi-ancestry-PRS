prsdir="/humgen/atgu1/fs03/yiwang/hapgen2/simulations/clump/profiles"
phenodir="/humgen/atgu1/fs03/yiwang/hapgen2/simulations/phenos"
outdir="/humgen/atgu1/fs03/yiwang/hapgen2/simulations/clump/outputs"

cd /humgen/atgu1/fs03/yiwang/hapgen2/simulations/scripts


pops="EUR AFR EAS"
seqs="1 2 3 4 5 6 7 10"

pop_base="EUR"
basebins=$(seq 4 4 52)
addbins=52

pop=${1}
M=${2}
h2=${3}
basebin=${4}
irep=${5}
pp=${6}

ldref1="EUR"
covs="NULL"
pc_numbers="NULL"
covfile="NULL"
pcfile="NULL"
popfile="NULL"

for addbin in $(seq 1 52);do


if [[ 2 -gt 1  ]]; then
tmp=("`ls ${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.S* | wc -l`")
echo ${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}


##using addPop as LD reference 

if [ $tmp == 8 ];then
echo "output1 exist"
else

for seq in ${seqs};do
tmp2=${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.S${seq}

if [ -f "$tmp2" ];then
	echo "output1 exist2"
	else
	Rscript 6_cal_accuracy.R --pop $pp --addpop ${pop} \
	--phenofile $phenodir/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}.phen \
	--covs ${covs} --pc_numbers ${pc_numbers} --covfile ${covfile} --pcfile ${pcfile} --popfile ${popfile} \
	--prsfile $prsdir/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}.S${seq}.sscore \
	--ldref ${pop} --out ${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${pop}.S${seq}
	fi
	done


	fi

	fi



	if  [[ 2 -gt 1  ]]; then

	##using EUR as LD reference 
	tmp=("`ls ${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${ldref1}.S* | wc -l`")
	echo ${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}

	if [ $tmp == 8 ];then
	echo "output1 exist"
	else
	for seq in ${seqs};do
	tmp2=${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${ldref1}.S${seq}
	if [ -f "$tmp2" ];then
		echo "output1 exist2"
		else
		Rscript 6_cal_accuracy.R --pop $pp --addpop ${pop} \
		--phenofile $phenodir/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}.phen \
		--covs ${covs} --pc_numbers ${pc_numbers} --covfile ${covfile} --pcfile ${pcfile} --popfile ${popfile}  \
		--prsfile $prsdir/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${ldref1}.S${seq}.sscore \
		--ldref ${ldref1} --out ${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-EURAdd${pop}_baseBin${basebin}addBin${addbin}_ldref${ldref1}.S${seq}
		fi
		done
		fi

		fi

		done

