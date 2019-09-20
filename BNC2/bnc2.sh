input="BNC2"
cd ~/hpc/rheumatology/RA/he2020
grep -w "BNC1\|BNC2\|LRRC37A3\|RDX\|ZNF670" ~/hpc/db/hg19/refGene.hg19.V2.bed | awk '{print $1,$2-20000,$3+20000,$5}' OFS="\t" | sort -u | bedtools sort -i > ROI.hg19.bed
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
touch readme.txt
echo  "Association of" $input "with rheumatoid arthritis" > readme.txt
plink --bfile ROI.dbsnp --hardy --out ROI
echo  "ROI.hwe: Hardy-Weinberg test statistics for each SNP for" $input. "SNPs in control group should not signficant which means P should higher than 0.05 or 0.01. this table will be put to supplementary table" > readme.txt
plink --bfile ROI.dbsnp --logistic --hwe 0.01 --adjust --ci 0.95 --out ROI
echo  "ROI.assoc.logistic: logistic based case-control test for" $input. "default style is to test additive model --ADD-- in logistic regression. this file will be one of most important table in the manuscript" >> readme.txt
echo  "ROI.assoc.logistic.adjusted: this file include all the multiple-test corrected P-value for each SNPs in" $input. " When you prepare the manuscript, this file should be integrate with above file --ROI.assoc.logistic--" >> readme.txt
plink --bfile ROI.dbsnp --assoc --counts --adjust --ci 0.95 --out ROI
echo  "ROI.assoc: Chi-square based case-control test for" $input. "this file will be one of most important table in the manuscript since it showed the number of alleles in case and control" > readme.txt
echo  "ROI.assoc.adjusted: this file include all the multiple-test corrected P-value --in the file: ROI.assoc-- for each SNPs in" $input. " When you prepare the manuscript, this file should be integrate with above file --ROI.assoc--" >> readme.txt
plink --bfile ROI.dbsnp --fisher --counts --adjust --ci 0.95 --out ROI
echo  'ROI.assoc.fisher: Fisher exact test based case-control association between SNPs and RA. This file will be useful when any cell lt 5. Usually when certain cell have number lt 5, we report fisher P-value not Chi-square P-value' >> readme.txt
echo  "ROI.assoc.fisher.adjusted: this file include all the multiple-test corrected P-value --in the file: ROI.assoc-- for each SNPs in" $input. " When you prepare the manuscript, this file should be integrate with above file --ROI.assoc--" >> readme.txt
plink --bfile ROI.dbsnp --model fisher --ci 0.95 --out ROI
echo  "ROI.model: Fisher's exact test based case-control association with different models for " $input. "this file is one of most important table in the manuscript" >> readme.txt
plink --bfile ROI.dbsnp --logistic --dominant --ci 0.95 --out ROI.dominant
echo  "ROI.dominant.assoc.logistic: logistic regression based association in dominant models for " $input. "this file is one of most important table in the manuscript. In the file of ROI.model, the DOM is based on fisher's exact test" >> readme.txt
plink --bfile ROI.dbsnp --logistic --recessive --ci 0.95 --out ROI.recessive
echo  "ROI.recessive.assoc.logistic: logistic regression based association in recessive models for " $input. "this file is one of most important table in the manuscript" >> readme.txt
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
