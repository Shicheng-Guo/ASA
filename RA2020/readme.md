merge 1st and 2nd plink files and upload to michigen
```
plink --file RA56 --merge RA57.ped RA57.map --recode --make-bed --out RA113
plink --bfile RA113 --bmerge he2019.bed he2019.bim he2019.fam --recode --make-bed --out RA2020
```
plink to vcf and upload
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
