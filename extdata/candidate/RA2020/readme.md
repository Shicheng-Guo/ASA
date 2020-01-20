
1. bcftools annotate plink-recode-vcf to replace old-non-dbsnp-id
```
gatk VariantAnnotator -R ~/hpc/db/hg19/hg19.fa -V chr22.dose.contig.vcf.gz -O chr22.dose.contig.dbSNP.vcf.gz --dbsnp ~/hpc/db/hg19/dbSNP152.GSC.hg19.vcf
```

