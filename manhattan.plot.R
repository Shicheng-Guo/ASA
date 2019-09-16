args = commandArgs(trailingOnly=TRUE)
mylimma<-read.table(args,head=T,sep="",check.names=F)
colnames(mylimma)=c("CHR","SNP","BP","A1","TEST","NMISS","OR","STAT","P")
manhattan.plot<-function(mylimma){
library(qqman)
CHR=mylimma$CHR
if(length(grep("X",CHR))>0){
  CHR<-sapply(CHR,function(x) gsub(pattern = "X",replacement = "23",x))
  CHR<-sapply(CHR,function(x) gsub(pattern = "Y",replacement = "24",x))
}
CHR<-as.numeric(CHR)
manhattaninput=data.frame(SNP=mylimma$SNP,CHR=CHR,BP=mylimma$BP,P=mylimma$P)
max<-max(2-log(manhattaninput$P,10))
genomewideline=0.05/nrow(manhattaninput)
seed=sample(seq(1,100000,by=1),1)
pdf(paste("manhattan.",seed,".pdf",sep=""))
manhattan(manhattaninput,col = c("blue4", "orange3"),ylim = c(0,10),genomewideline=-log10(genomewideline),lwd=2, suggestiveline=F)
dev.off()
}
manhattan.plot(mylimma)
