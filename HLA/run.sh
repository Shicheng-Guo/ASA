#################miRNA##############################################
cd /gpfs/home/guosa/hpc/rheumatology/RA/he2020/impute/R3
for i in {1..22} X 
do 
bcftools view -R HLA.txt chr$i.dose.dbSNP.hg19.vcf.gz -Oz -o ./HLA/chr$i.dose.dbSNP.miRNA.hg19.vcf.gz
tabix -p vcf ./HLA/chr$i.dose.dbSNP.miRNA.hg19.vcf.gz
echo $i
done

cd HLA
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
plink --bfile RA.dose.dbSNP.miRNA.hg19 --counts --assoc --adjust --out RA.dose.dbSNP.miRNA.counts.hg19

17	80627188
11	76329590

rs12379034
rs12617656	2	162851147
