1. collected genomic position of all the MUC genes (hg19). -5k and +5K to cover SNPs in promoter and enhancer regions. 
```
grep MUC ~/hpc/db/hg19/refGene.hg19.bed | awk '{print $1,$2-5000,$3+5000,$4}' OFS="\t" | bedtools sort -i > MUC.hg19.sort.bed
```
2. extract genotypes for MUC genes
```
cd /gpfs/home/guosa/hpc/rheumatology/RA/he2020/impute/R3
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
echo tabix -f -p vcf chr$i.dose.dbSNP.hg19.vcf.gz >> $i.job
echo bcftools view -i \'R2\>0.6\|TYPED=1\|TYPED_ONLY=1\' -R MUC.hg19.sort.bed chr$i.dose.dbSNP.hg19.vcf.gz \|  bcftools annotate -x \^FORMAT/GT -Oz -o chr$i.dose.MUC.clean.hg19.vcf.gz  >>$i.job
qsub $i.job
done
```
3. concat all the MUC genotypes from chr1 to chr22
```
ls chr*.dose.MUC.clean.hg19.vcf.gz > MUC.vcf.txt
bcftools concat -f MUC.vcf.txt -Oz -o MUC.hg19.vcf.gz
```
4. annotate gene symbol to vcf files. In order to add gene symbol to vcf file, we need a bed.gz file includes chr,start,end,symbol. bed.gz should be index with tabix. You can download these two file from the following sites: 

https://github.com/Shicheng-Guo/AnnotationDatabase/blob/master/hg19/refGene.hg19.VCF.sort.bed.gz

https://github.com/Shicheng-Guo/AnnotationDatabase/blob/master/hg19/refGene.hg19.VCF.sort.bed.gz.tbi
```
bcftools annotate -a ~/hpc/db/hg19/refGene.hg19.VCF.sort.bed.gz -c CHROM,FROM,TO,GENE -h <(echo '##INFO=<ID=GENE,Number=1,Type=String,Description="Gene name">') MUC.hg19.vcf.gz -Oz -o MUC.anno.hg19.vcf.gz
```
5. check several positive SNPs
```
bcftools view -i '%iD=="rs35705950"' MUC.anno.hg19.vcf.gz | less -S 
bcftools view -i '%iD=="rs79920422"' MUC.anno.hg19.vcf.gz | less -S 
```
 
