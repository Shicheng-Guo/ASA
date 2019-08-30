

```
cd ~/hpc/rheumatology/RA/he2019/plink/vcf
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
echo bcftools view RA113.chr$i.vcf -Oz -o RA113.chr$i.vcf.gz >>$i.job
echo tabix -f -p vcf RA113.chr$i.vcf.gz >> $i.job
qsub $i.job
done
```
