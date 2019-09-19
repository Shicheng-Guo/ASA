input="CSF"
cd ~/hpc/rheumatology/RA/he2020
grep $input ~/hpc/db/hg19/refGene.hg19.V2.bed | awk '{print $1,$2-20000,$3+20000,$5}' OFS="\t" | sort -u | bedtools sort -i > ROI.hg19.bed
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
plink --bfile ROI.dbsnp --assoc --counts --adjust --ci 0.95 --out ROI.chisq
plink --bfile ROI.dbsnp --logistic --adjust --ci 0.95 --out ROI.logistic
plink --bfile ROI.dbsnp --fisher --counts --adjust --ci 0.95 --out ROI.fisher
plink --bfile ROI.dbsnp --model --ci 0.95 --out ROI.chisq
plink --bfile ROI.dbsnp --model --fisher --ci 0.95 --out ROI.fisher
plink --bfile ROI.dbsnp --logistic --genotypic --fisher --ci 0.95 --out ROI.genotype.fisher
plink --bfile ROI.dbsnp --logistic --genotypic --ci 0.95 --out ROI.genotype.chisq
plink --bfile ROI.dbsnp --logistic --dominant --fisher --ci 0.95 --out ROI.dominant
plink --bfile ROI.dbsnp --logistic --recessive --fisher --ci 0.95 --out ROI.recessive
/gpfs/home/guosa/hpc/tools/plink-1.07-x86_64/plink --bfile ROI.dbsnp --hap-window 2,3,4,5,6 --hap-assoc --out haplotype --noweb
