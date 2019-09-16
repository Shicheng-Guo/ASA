cd ~/hpc/rheumatology/RA/he2020
plink --bfile RA2020 --mind 01 --make-bed --out RA2020-B1
plink --bfile RA2020-B1 --geno 0.1 --make-bed --out RA2020-B2
plink --bfile RA2020-B2 --maf 0.01 --make-bed --out RA2020-B3
plink --bfile RA2020-B3 --hwe 0.00001 --make-bed --out RA2020-B4
plink2 --bfile RA2020-B4 --king-cutoff 0.125
plink2 --bfile RA2020-B4 --remove plink2.king.cutoff.out.id --make-bed -out RA2020-B5
plink --bfile RA2020-B5 --check-sex
plink --bfile RA2020-B5 --impute-sex --make-bed --out RA2020-B6
plink --bfile RA2020-B6 --check-sex
grep PROBLEM plink.sexcheck | awk '{print $1,$2}' > sexcheck.remove
plink --bfile RA2020-B6 --remove sexcheck.remove --make-bed --out RA2020-B7
plink --bfile RA2020-B7 --test-missing midp 
awk '$5<0.000001{print}' plink.missing | awk '{print $2}' > missing.imblance.remove
plink --bfile RA2020-B7 --exclude missing.imblance.remove --make-bed --out RA2020-B8
plink --bfile RA2020-B8 --pca --threads 31
perl phen.pl RA2020-B8.fam > RA2020-B8.fam.new
mv RA2020-B8.fam.new RA2020-B8.fam
plink --bfile RA2020-B8 --logistic --covar plink.eigenvec --covar-number 1-5 --adjust
plink --bfile RA2020-B8 --assoc mperm=1000000 --adjust gc --threads 31
grep "ADD\|NMISS" plink.assoc.logistic > plink.assoc.logistic.add
wget https://raw.githubusercontent.com/Shicheng-Guo/ASA/master/manhattan.plot.R -O manhattan.plot.R
Rscript manhattan.plot.R plink.assoc.logistic.add
## local
head -n 50 plink.assoc.logistic.adjusted

rs="rs17499655"
chr="6"
plink --bfile RA2020-B8.dbsnp --snp $rs --window 500 --make-bed --out $rs
plink --bfile $rs --logistic --covar plink.eigenvec --covar-number 1-5 --adjust --out $rs
plink --bfile $rs --r2 --ld-snp $rs --ld-window-kb 1000 --ld-window 99999  --ld-window-r2 0  --out $rs
perl local.pl  > $rs
wc -l plink.ld
grep "ADD\|NMISS" plink.assoc.logistic > plink.assoc.logistic.add
wget https://raw.githubusercontent.com/Shicheng-Guo/ASA/master/localhit.pl -O localhit.pl
perl localhit.pl $rs > $rs.local
wget https://raw.githubusercontent.com/Shicheng-Guo/GscRbasement/master/make.fancy.locus.plot.unix.R -O make.fancy.locus.plot.unix.R
Rscript make.fancy.locus.plot.unix.R rs9972241 rs9972241 $chr $rs.local 20 0.00005
