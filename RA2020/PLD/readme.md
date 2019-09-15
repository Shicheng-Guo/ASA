```
cd ~/hpc/rheumatology/RA/he2020
grep PLD ~/hpc/db/hg19/refGene.hg19.V2.bed | awk '{print $1,$2-10000,$3+10000,$5}' OFS="\t" | sort -u | bedtools sort -i | bedtools merge -i - > PLD.hg19.bed
```
