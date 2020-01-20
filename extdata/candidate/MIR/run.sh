cd /gpfs/home/guosa/hpc/rheumatology/RA/he2020/impute/R3
wget https://raw.githubusercontent.com/Shicheng-Guo/AnnotationDatabase/master/hg19/miRNA/miRNA-SNP/215miRnaSNP.txt -O miRNAcommonSNP.txt
awk '{print $1,$2}' OFS="\t" miRNAcommonSNP.txt > miRNAhg19SNP.txt
for i in {1..22} X 
do 
bcftools view -R miRNAhg19SNP.txt chr$i.dose.dbSNP.hg19.vcf.gz -Oz -o ./miRNA/chr$i.dose.dbSNP.miRNA.hg19.vcf.gz
tabix -p vcf ./miRNA/chr$i.dose.dbSNP.miRNA.hg19.vcf.gz
echo $i
done
cd miRNA
ls chr*.dose.dbSNP.miRNA.hg19.vcf.gz > filelist.txt
bcftools concat -f filelist.txt -Oz -o RA.dose.dbSNP.miRNA.hg19.vcf.gz
plink --vcf RA.dose.dbSNP.miRNA.hg19.vcf.gz --make-bed --out RA.dose.dbSNP.miRNA.hg19
perl ../plink/phen.pl RA.dose.dbSNP.miRNA.hg19.fam > mylist.txt
plink --vcf RA.dose.dbSNP.miRNA.hg19.vcf.gz --keep mylist.txt --make-bed --out RA.dose.dbSNP.miRNA.hg19
perl ../plink/phen.pl RA.dose.dbSNP.miRNA.hg19.fam > RA.dose.dbSNP.miRNA.hg19.fam.new
wc -l RA.dose.dbSNP.miRNA.hg19.fam
wc -l RA.dose.dbSNP.miRNA.hg19.fam.new
mv RA.dose.dbSNP.miRNA.hg19.fam.new RA.dose.dbSNP.miRNA.hg19.fam
plink --bfile RA.dose.dbSNP.miRNA.hg19 --freq --logistic --adjust --out RA.dose.dbSNP.miRNA.hg19
plink --bfile RA.dose.dbSNP.miRNA.hg19 --assoc --adjust --out RA.dose.dbSNP.miRNA.hg19
head plink.assoc.logistic.adjusted
head plink.assoc.adjusted
head plink.assoc

plink --bfile RA.dose.dbSNP.miRNA.hg19 --snp rs2273626 --assoc mperm=1000000 --adjust  --threads 10 --out rs2273626
plink --bfile RA.dose.dbSNP.miRNA.hg19 --snp rs2620381 --assoc mperm=1000000 --adjust  --threads 10 --out rs2273626

grep rs2273626 plink.frq
grep rs2620381 plink.frq
