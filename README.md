# ASA

* rs8896 in ASA, when you search rs8896 in gnomAD, you will find two records (multiallelic): G->A and GCACCCCCTC-G
* rs375927883 in ASA, when you search rs375927883 in dbsnp, you will find there is no record for rs375927883

### Processing GWAS Dataset

* Step 1. plink data to vcf data by chrosome

```
for i in {1..26}
do
plink --bfile he2019 --chr $i --recode vcf --out ./vcf/he2009.chr$i
done
```
* Step 2. Using bcftools to depress vcf and tabix index

```
cd /gpfs/home/guosa/hpc/rheumatology/RA/he2019/vcf
mkdir temp
for i in {1..24}
do
echo \#PBS -N $i  > $i.job
echo \#PBS -l nodes=1:ppn=1 >> $i.job
echo \#PBS -M Guo.shicheng\@marshfieldresearch.org >> $i.job
echo \#PBS -m abe  >> $i.job
echo \#PBS -o $(pwd)/temp/ >>$i.job
echo \#PBS -e $(pwd)/temp/ >>$i.job
echo cd $(pwd) >> $i.job
echo bcftools view he2009.chr$i.vcf -Oz -o he2009.chr$i.vcf.gz >>$i.job
echo tabix -f -p vcf he2009.chr$i.vcf.gz >> $i.job
qsub $i.job
done
```
* Step 3. Upload to [Michigan Imputation Server](https://imputationserver.sph.umich.edu) for imputation and ID replacement (imputation and phasing). 

