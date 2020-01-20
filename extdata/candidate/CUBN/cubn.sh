rm ROI.hg19.bed 
for input in CUBN ASTL BMP1 C1R C1S CDCP2 CNTNAP1 CNTNAP2 CNTNAP3 CNTNAP3B CNTNAP3C CNTNAP4 CNTNAP5 CP CSMD1 CSMD2 CSMD3 CUZD1 DCBLD2 DLL3 DMBT1 EDIL3 ENSG00000286088 EYS F5 F8 F9 FBN3 HEPH HEPHL1 LRP1B MASP1 MEP1A MEP1B MFGE8 MFRP NETO1 NETO2 NOTCH2 NOTCH3 NRP1 NRP2 NRXN1 NRXN2 NRXN3 OVCH2 PCOLCE PCOLCE2 PDGFC PDGFD SCUBE2 SEZ6 SEZ6L SEZ6L2 SLIT2 SLIT3 TLL1 TLL2 VWDE 
do
grep $input ~/hpc/db/hg19/refGene.hg19.V2.bed | awk '{print $1,$2-20000,$3+20000,$5}' OFS="\t" | sort -u | bedtools sort -i >> ROI.hg19.bed
done
input="CUBN"

mkdir $input
plink --bfile RA2020-B8 --extract range ROI.hg19.bed --make-bed --out ./$input/ROI
cp ROI.hg19.bed ./$input/
cd $input
plink --bfile ROI --recode vcf --out ROI
bcftools view ROI.vcf -Oz -o ROI.vcf.gz
tabix -p vcf ROI.vcf.gz
bcftools annotate -a ~/hpc/db/hg19/dbSNP/All_20180423.hg19.vcf.gz -c ID ROI.vcf.gz -Oz -o ROI.hg19.vcf.gz
bcftools annotate -a ~/hpc/db/hg19/refGene.hg19.VCF.sort.bed.gz -c CHROM,FROM,TO,GENE -h <(echo '##INFO=<ID=GENE,Number=1,Type=String,Description="Gene name">') ROI.hg19.vcf.gz -Oz -o ROI.hg19.refGene.vcf.gz
plink --vcf ROI.hg19.vcf.gz --make-bed --out ROI.dbsnp
cp ROI.fam ROI.dbsnp.fam
touch readme.txt
plink --bfile ROI.dbsnp --logistic --adjust --ci 0.95 --out ROI
plink --bfile ROI.dbsnp --assoc --counts --adjust --ci 0.95 --out ROI
plink --bfile ROI.dbsnp --fisher --counts --adjust --ci 0.95 --out ROI
plink --bfile ROI.dbsnp --model fisher --ci 0.95 --out ROI
plink --bfile ROI.dbsnp --logistic --genotypic --ci 0.95 --out ROI.genotype
plink --bfile ROI.dbsnp --logistic --dominant --ci 0.95 --out ROI.dominant
plink --bfile ROI.dbsnp --logistic --recessive --ci 0.95 --out ROI.recessive
~/hpc/tools/plink-1.07-x86_64/plink --bfile ROI.dbsnp --hap-window 2,3,4,5,6 --hap-assoc --out haplotype --noweb

wget https://raw.githubusercontent.com/Shicheng-Guo/ASA/master/manhattan.plot.R -O manhattan.plot.R
awk '$5=="ADD"{print}' ROI.assoc.logistic > plink.assoc.logistic.add
Rscript manhattan.plot.R plink.assoc.logistic.add

	 
	 
