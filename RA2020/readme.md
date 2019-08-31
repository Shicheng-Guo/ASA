1. merge 1st and 2nd plink files and upload to michigen
```
plink --file RA56 --merge RA57.ped RA57.map --recode --make-bed --out RA113
plink --bfile RA113 --bmerge he2019.bed he2019.bim he2019.fam --recode --make-bed --out RA2020
```
2. plink to vcf and upload
```
cd /gpfs/home/guosa/hpc/rheumatology/RA/he2020
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
echo bcftools view he2020.chr$i.vcf -Oz -o ./vcfupload/he2020.chr$i.vcf.gz >>$i.job
qsub $i.job
done
```
3. add contig length to michigen imputation server output vcf.gz files since contig length information was lost (rsq>0.3) 
```
cd /gpfs/home/guosa/hpc/rheumatology/RA/he2020/impute/R3
mkdir temp
wget https://raw.githubusercontent.com/Shicheng-Guo/Gscutility/master/contigReplace.pl
for i in {1..22}
do
echo \#PBS -N $i  > $i.job
echo \#PBS -l nodes=1:ppn=1 >> $i.job
echo \#PBS -M Guo.shicheng\@marshfieldresearch.org >> $i.job
echo \#PBS -m abe  >> $i.job
echo \#PBS -o $(pwd)/temp/ >>$i.job
echo \#PBS -e $(pwd)/temp/ >>$i.job
echo cd $(pwd) >> $i.job
echo perl contigReplace.pl $i \| bgzip -c \> chr$i.dose.contig.vcf.gz >>$i.job
echo tabix -p vcf chr$i.dose.contig.vcf.gz >>$i.job
qsub $i.job
done
```
4. gatk annotate dbSNPs
```
gatk VariantAnnotator -R ~/hpc/db/hg19/hg19.fa -V chr22.dose.contig.vcf.gz -O chr22.dose.contig.dbSNP.vcf.gz --dbsnp ~/hpc/db/hg19/dbSNP152.GSC.hg19.vcf
```

