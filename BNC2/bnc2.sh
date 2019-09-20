input="BNC2"
cd ~/hpc/rheumatology/RA/he2020
grep -w "BNC1\|BNC2\|LRRC37A3\|RDX\|ZNF670" ~/hpc/db/hg19/refGene.hg19.V2.bed | awk '{print $1,$2-50000,$3+50000,$5}' OFS="\t" | sort -u | bedtools sort -i > ROI.hg19.bed
mkdir $input
plink --bfile RA2020-B8.dbsnp --extract range ROI.hg19.bed --make-bed --out ./$input/ROI
cd $input
wget https://raw.githubusercontent.com/Shicheng-Guo/GscRbasement/master/manhattan.qqplot.R -O manhattan.plot.R
wget https://raw.githubusercontent.com/Shicheng-Guo/GscRbasement/master/make.fancy.locus.plot.unix.R -O make.fancy.locus.plot.unix.R
wget https://raw.githubusercontent.com/Shicheng-Guo/Gscutility/master/localhit.pl -O localhit.pl
plink --bfile ROI --recode vcf --out ROI
bcftools view ROI.vcf -Oz -o ROI.vcf.gz
tabix -p vcf ROI.vcf.gz
bcftools annotate -a ~/hpc/db/hg19/refGene.hg19.VCF.sort.bed.gz -c CHROM,FROM,TO,GENE -h <(echo '##INFO=<ID=GENE,Number=1,Type=String,Description="Gene name">') ROI.vcf.gz -Ov -o ROI.refGene.vcf
plink --vcf ROI.vcf.gz --make-bed --out ROI.dbsnp
cp ROI.fam ROI.dbsnp.fam
sleep 30
touch readme.md
echo  "### Novel Genetic susceptibility loci in" $input "associated with rheumatoid arthritis" > readme.md
sleep 30
touch readme.txt
bcftools view -G ROI.refGene.vcf -Ov -o ROI.refGene.vcf.txt
echo  "Title: Novel Genetic susceptibility loci in" $input "associated with rheumatoid arthritis" > readme.txt
echo "" >> readme.txt
plink --bfile ROI.dbsnp --hardy --out ROI
echo  "ROI.hwe: Hardy-Weinberg test statistics for each SNP for" $input. "SNPs in control group should not signficant which means P should higher than 0.05 or 0.01. this table will be put to supplementary table" >> readme.txt
plink --bfile ROI.dbsnp --logistic --hwe 0.01 --adjust --ci 0.95 --out ROI
echo  "ROI.assoc.logistic: logistic based case-control test for" $input. "default style is to test additive model --ADD-- in logistic regression. this file will be one of most important table in the manuscript" >> readme.txt
echo  "ROI.assoc.logistic.adjusted: this file include all the multiple-test corrected P-value for each SNPs in" $input. " When you prepare the manuscript, this file should be integrate with above file --ROI.assoc.logistic--" >> readme.txt
plink --bfile ROI.dbsnp --assoc --counts --adjust --ci 0.95 --out ROI
echo  "ROI.assoc: Chi-square based case-control test for" $input. "this file will be one of most important table in the manuscript since it showed the number of alleles in case and control" >> readme.txt
echo  "ROI.assoc.adjusted: this file include all the multiple-test corrected P-value --in the file: ROI.assoc-- for each SNPs in" $input. " When you prepare the manuscript, this file should be integrate with above file --ROI.assoc--" >> readme.txt
plink --bfile ROI.dbsnp --fisher --counts --adjust --ci 0.95 --out ROI
echo  'ROI.assoc.fisher: Fisher exact test based case-control association between SNPs and RA. This file will be useful when any cell lt 5. Usually when certain cell have number lt 5, we report fisher P-value not Chi-square P-value' >> readme.txt
echo  "ROI.assoc.fisher.adjusted: this file include all the multiple-test corrected P-value --in the file: ROI.assoc-- for each SNPs in" $input. " When you prepare the manuscript, this file should be integrate with above file --ROI.assoc--" >> readme.txt
plink --bfile ROI.dbsnp --model fisher --ci 0.95 --out ROI
echo  "ROI.model: Fisher's exact test based case-control association with different models for" $input. "this file is one of most important table in the manuscript" >> readme.txt
plink --bfile ROI.dbsnp --logistic --dominant --ci 0.95 --out ROI.dominant
echo  "ROI.dominant.assoc.logistic: logistic regression based association in dominant models for" $input. "this file is one of most important table in the manuscript. In the file of ROI.model, the DOM is based on fisher's exact test" >> readme.txt
plink --bfile ROI.dbsnp --logistic --recessive --ci 0.95 --out ROI.recessive
echo  "ROI.recessive.assoc.logistic: logistic regression based association in recessive models for" $input. "this file is one of most important table in the manuscript" >> readme.txt
~/hpc/tools/plink-1.07-x86_64/plink --bfile ROI.dbsnp --hap-window 2,3,4,5,6 --hap-assoc --out haplotype --noweb
echo  'haplotype.assoc.hap: chi-square test based haplotype association. This file is important which can be shown with significant haplotype as a table in the manuscript' >> readme.txt
awk '$6=="NMISS"{print}' ROI.assoc.logistic > ROI.assoc.logistic.add
awk '$5=="ADD"{print}' ROI.assoc.logistic >> ROI.assoc.logistic.add
Rscript manhattan.plot.R ROI.assoc.logistic.add
sort -k12,12 ROI.assoc.logistic
rs="rs75958865"
plink --bfile ../RA2020-B8.dbsnp --r2 --ld-snp $rs --ld-window-kb 100 --ld-window 99999 --ld-window-r2 0 --out $rs
perl localhit.pl $rs > $rs.local
Rscript make.fancy.locus.plot.unix.R $rs $rs 9 $rs.local 6 0.05
rm *.R
rm *.pl
echo "" >> readme.txt
echo  'Abstract: The heritability of RA has been shown from twin studies to be 60%. Since 2007, rapid advances in technology underpinning the use of genome-wide association studies have allowed the identification of hundreds of genetic risk factors for many complex diseases. There are now >100 genetic loci that have been associated with RA. In the previous study, the contribution of HLA to heritability has been estimated to be 11–37% while 100 non-HLA loci were shown to explain 4.7% of the heritability of RA in Asians. The majority of the heritability is still missing.' $input ' have xxxxxx function which might be invovled in  pathology of RA. therefore, In this study, we conducted assocation study to investigate the role of xx and its paralog genes and in RA. in the first stage, we colllected 1078 RA and 1045 matched control. xxx SNPs in xx, xxx, xxx, xx were genotyped. We found SNPs rsxxx in xxx was signifciantly associated with RA, P=xxx, 95%CI.' >> readme.txt
