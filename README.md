# Pipeline for analyses in multi-ancestry-PRS

<br>

## 1. Generate plink files using QCd variants
- maf 0.01, geno 0.05, mind 0.1, hwe 1e-6, info 0.3

<br>

## 2. Randomly sample 5K individuals as hold-out dataset for all phenotypes
- for individuals with non-missing values across all studied phenotypes
- randomly sample 5K individuals

After filling the variables in ```subset5k.sh```, specifically:

Options:

	--phenofile=PHENOFILE
		Full path to phenotype files with IID or FID/IID included in the headers

	--rel05_list=REL05_LIST
		Full path to the file listing all unrelated individuals in that specific ancestry (in the order of FID, IID)

	--holdout_file=HOLDOUT_FILE
		Full path to the file storing hold-out sample ids (FID, IID)
		
Then run:

```bash subset5k.sh```

<br>

## 3. Split the remaining individuals to bins with equal sample size (5K)
- Excluding the hold-out samples
- Evenly split the randomly ordered individuals (N=5K) in the remaining dataset

After filling the variables in ```splitBins.sh```, specifically:

Options:

	--phenofile=PHENOFILE
		Full path to phenotype files with IID included in the headers

	--all_phenos=ALL_PHENOS
		a vector of phenotypes, separated by comma

	--rel05_list=REL05_LIST
		Full path to the file listing all unrelated individuals in that specific ancestry (in the order of FID, IID)

	--holdout=HOLDOUT
		Full path to the file listing hold-out sample ids (FID, IID)

	--outdir=OUTDIR
		Full path to the directory of output file storing ids as well as phenotype for each phenotype per bin

	--summary_bins_file=SUMMARY_BINS_FILE
		Full path to output file summarising number of splitted bins for all phenotypes

		
Then run:

```bash splitBins.sh```

<br>

## 4. Run GWAS
- Run GWAS in each bin for each phenotype

After filling the variables in ```GWAS.sh```, specifically:

Options:

	--bfile_prefix=BFILE_PREFIX
		Full path to genoytype files (Here bfile format is used)

	--phenodir=PHENODIR
		Full path to the directory of phenotype file for each bin generated in splitBins.R

	--pheno=PHENO
		Phenotype name to run GWAS

	--bin_number=BIN_NUMBER
		The No. of bin to run GWAS

	--n_threads=N_THREADS
		Number of threads to run PLINK2

	--summary_bins_file=SUMMARY_BINS_FILE
		Full path to output file summarising number of splitted bins for all phenotypes

	--out_prefix=OUT_PREFIX
		Prefix with full path to the output file of GWAS results for each phenotype per bin

		
Then run:

```bash GWAS.sh```

<br>

## 5. Merge GWAS across chromosomes

In this step, the .afreq and .linear files will be merged into a .linear.gz file.

After filling the variables in ```merge_GWAS_acrossCHRs.sh```:

	--gwasdir=GWASDIR
		Full path to the directory of GWAS .linear and .afreq outputs per chromosome for each phenotype per bin

	--out_prefix=OUT_PREFIX
		Prefix (no need to specify chromosme number) to the output file of GWAS results .linear and .afreq per chromosme for each phenotype per bin, specified in GWAS.sh

	--pheno=PHENO
		Phenotype name to run GWAS

	--summary_bins_file=SUMMARY_BINS_FILE
		Full path to output file summarising number of splitted bins for all phenotypes

	--bin_number=BIN_NUMBER
		The No. of bin to merge GWAS outputs

	--out_dir=OUT_DIR
		Full path to the directory of merged GWAS for each phenotype per bin

	-h, --help
		Show this help message and exit
		

Then run `bash ./merge_GWAS_acrossCHRs.sh`. 

Note for *out_prefix* it is similar to a regex pattern, without the need to specifiy chromosome number, e.g., ```--out_prefix="ukb_eurs_chr```.



