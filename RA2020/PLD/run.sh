```
cd ~/hpc/rheumatology/RA/he2020
grep "PL" ~/hpc/db/hg19/refGene.hg19.V2.bed | awk '{print $1,$2-10000,$3+10000,$5}' OFS="\t" | sort -u | bedtools sort -i > PLD.hg19.bed
wget https://raw.githubusercontent.com/Shicheng-Guo/ASA/master/RA2020/PLD/Phospholipase.txt -O Phospholipase.txt
grep -w -f Phospholipase.txt PLD.hg19.bed > PLD.hg19.vcf.bed

input="RA2020-B8.vcf"
bcftools view $input -Oz -o $input.gz
tabix -p vcf $input.gz
bcftools annotate -a ~/hpc/db/hg19/dbSNP/All_20180423.hg19.vcf.gz -c ID $input.gz -Oz -o $input.hg19.gz
```
