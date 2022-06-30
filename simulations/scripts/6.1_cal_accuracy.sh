prsdir="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/clump/profiles/single_pop"
phenodir="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/phenos"
outdir="/humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/clump/outputs/single_pop"

cd /humgen/atgu1/fs03/yiwang/hapgen2/multi-ancestry-PRS/simulations/scripts


pps="EUR AFR EAS"
seqs="1 2 3 4 5 6 7 10"


addbin=${1}
M=${2}
h2=${3}
irep=${4}


covs="NULL"
pc_numbers="NULL"
covfile="NULL"
pcfile="NULL"
popfile="NULL"

for pp in ${pps};do

if [[ 2 -gt 1  ]]; then
tmp=("`ls ${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}.S* | wc -l`")
echo ${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}


##using addPop as LD reference 

if [ $tmp == 8 ];then
echo "output1 exist"
else

for seq in ${seqs};do
tmp2=${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}.S${seq}

if [ -f "$tmp2" ];then
	echo "output1 exist2"
	else
	Rscript 6_cal_accuracy.R --pop $pp --addpop ${pp} \
	--phenofile $phenodir/caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}.phen \
	--covs ${covs} --pc_numbers ${pc_numbers} --covfile ${covfile} --pcfile ${pcfile} --popfile ${popfile} \
	--prsfile $prsdir/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}.S${seq}.sscore \
	--ldref ${pp} --out ${outdir}/${pp}_caus${M}-rep${irep}-h2_${h2}-S1_-1-${pp}_Bin1toBin${addbin}.S${seq}
	fi
	done


	fi

	fi


	done

