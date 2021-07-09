# multi-ancestry-PRS

## 1. Generate plink files using QCd variants
- maf 0.01, geno 0.05, mind 0.1, hwe 1e-6

## 2. Randomly sample 5K individuals as hold-out dataset for all phenotypes
- for individuals with non-missing values across all studied phenotypes
- randomly sample 5K individuals

## 3. Split the remaining individuals to bins with equal sample size (5K)
- Excluding the hold-out samples
- Evenly split the randomly ordered in the remaining individuals

## 4. Run GWAS
- Run GWAS in each bin for each phenotype
