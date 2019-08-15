plink --bfile he2019 --assoc --count --maf 0.05 --allow-no-sex --1

plink<-read.table("plink.assoc",head=T)
ManhattanPlot<-function(mylimma){
library(qqman)
res <- mylimma
SNP=res$SNP
CHR=res$CHR
if(length(grep("X",CHR))>0){
  CHR<-sapply(CHR,function(x) gsub(pattern = "X",replacement = "23",x))
  CHR<-sapply(CHR,function(x) gsub(pattern = "Y",replacement = "24",x))
}
CHR<-as.numeric(CHR)
BP=res$BP
P=res$P
manhattaninput=na.omit(data.frame(SNP,CHR,BP,P))
genomewideline=0.05/nrow(manhattaninput)
pdf("assoc.manhattan.pdf")
manhattan(manhattaninput,col = c("blue4", "orange3"),ylim = c(0,30),genomewideline=F,lwd=2, suggestiveline=F)
dev.off()
}
ManhattanPlot(plink)
plink$logP<--log(plink$P,10)

sigplink<-subset(plink, logP>10)

plink --bfile he2019 --logistic --covar plink.eigenvec --covar-number 1-6 --allow-no-sex --1
ManhattanPlot<-function(mylimma){
library(qqman)
res <- mylimma
SNP=res$SNP
CHR=res$CHR
if(length(grep("X",CHR))>0){
  CHR<-sapply(CHR,function(x) gsub(pattern = "X",replacement = "23",x))
  CHR<-sapply(CHR,function(x) gsub(pattern = "Y",replacement = "24",x))
}
CHR<-as.numeric(CHR)
BP=res$BP
P=res$P
manhattaninput=na.omit(data.frame(SNP,CHR,BP,P))
genomewideline=0.05/nrow(manhattaninput)
head(manhattaninput)
dim(manhattaninput)
pdf("manhattan.pdf")
manhattan(manhattaninput,col = c("blue4", "orange3"),ylim = c(0,20),genomewideline=-log10(genomewideline),lwd=2, suggestiveline=F)
dev.off()
}
plink<-read.table("plink.assoc.logistic",head=T)
mylimma<-subset(plink,TEST=="ADD")
ManhattanPlot(plink)
/home/guosa/hpc/rheumatology/RA/he2019/sigplink.bed

for i in {1..26}
do
plink --bfile he2019 --chr $i --recode vcf --out ./vcf/he2009.chr$i
done

cd /gpfs/home/guosa/hpc/rheumatology/RA/he2019/vcf
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
echo bcftools view he2009.chr$i.vcf -Oz -o he2009.chr$i.vcf.gz >>$i.job
echo tabix -f -p vcf he2009.chr$i.vcf.gz >> $i.job
qsub $i.job
done

cd /gpfs/home/guosa/hpc/rheumatology/RA/he2019/impute
mkdir temp
for i in {1..22}
do
echo \#PBS -N $i  > $i.job
echo \#PBS -l nodes=1:ppn=1 >> $i.job
echo \#PBS -M Guo.shicheng\@marshfieldresearch.org >> $i.job
echo \#PBS -m abe  >> $i.job
echo \#PBS -o $(pwd)/temp/ >>$i.job
echo \#PBS -e $(pwd)/temp/ >>$i.job
echo cd $(pwd) >> $i.job
echo wget https://imputationserver.sph.umich.edu/share/results/f3bd4c751822ad5b595f84ddce8633dd/chr_$i.zip  >>$i.job
qsub $i.job
done

wget https://imputationserver.sph.umich.edu/share/results/f3bd4c751822ad5b595f84ddce8633dd/chr_1.zip
wget https://imputationserver.sph.umich.edu/share/results/4a40083b89985685aa7497410b76de2e/chr_10.zip
wget https://imputationserver.sph.umich.edu/share/results/bed7f5623a79df56011c415de914bea8/chr_11.zip
wget https://imputationserver.sph.umich.edu/share/results/578ff3fa346da5c04804abdb0eb93900/chr_12.zip
wget https://imputationserver.sph.umich.edu/share/results/1ad44aa0169dacd18d2328a4d08cd9f5/chr_13.zip
wget https://imputationserver.sph.umich.edu/share/results/1182c8c1af253aa56b9b5b9002a2575a/chr_14.zip
wget https://imputationserver.sph.umich.edu/share/results/86825c0065032220e8d74c811396debe/chr_15.zip
wget https://imputationserver.sph.umich.edu/share/results/fb068bed6ec28f6c19c08c1f62ac508c/chr_16.zip
wget https://imputationserver.sph.umich.edu/share/results/f1d226ea4115c6c5c05f84bb6a7fedb8/chr_17.zip
wget https://imputationserver.sph.umich.edu/share/results/54bdee5c147c31f77b2ce393eb1be295/chr_18.zip
wget https://imputationserver.sph.umich.edu/share/results/220100a69422665935a46cd3733112b0/chr_19.zip
wget https://imputationserver.sph.umich.edu/share/results/2c20372088ebc27233341ab964641baa/chr_20.zip
wget https://imputationserver.sph.umich.edu/share/results/bfca52b60d40dbe2965464e9b93dcb1c/chr_21.zip
wget https://imputationserver.sph.umich.edu/share/results/beabe65757681d5f4e5f5cb068a4e58b/chr_22.zip
wget https://imputationserver.sph.umich.edu/share/results/4593e713bc69c4072b380bc7a4c037a9/chr_3.zip
wget https://imputationserver.sph.umich.edu/share/results/e42511c91c695d1153ac5a48c32231e2/chr_4.zip
wget https://imputationserver.sph.umich.edu/share/results/26565945d9d95c950f0db8c9afb11f3c/chr_5.zip
wget https://imputationserver.sph.umich.edu/share/results/c5c56e404c061669b4e26d0bdefdbd49/chr_6.zip
wget https://imputationserver.sph.umich.edu/share/results/8f6da5b2dda3e67f3933170ae23b10bd/chr_7.zip
wget https://imputationserver.sph.umich.edu/share/results/39678907b07f5517f6af388ff1d962a1/chr_8.zip
wget https://imputationserver.sph.umich.edu/share/results/3c6ed7d7031cf5e28ef9b0cf9b6d3992/chr_9.zip

for i in {1..22}
do
unzip -P gK?9sQr5bTtJZR chr_$i.zip 
done
