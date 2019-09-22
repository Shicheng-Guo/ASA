# NCBI36 or hg18
wget http://zzz.bwh.harvard.edu/plink/dist/hapmap_r23a.zip
wget http://zzz.bwh.harvard.edu/plink/dist/hapmap.pop
unzip hapmap_r23a.zip

# download database and script
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/liftOver
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg18/liftOver/hg18ToHg19.over.chain.gz
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz
wget https://raw.githubusercontent.com/Shicheng-Guo/GscPythonUtility/master/liftOverPlink.py
wget https://raw.githubusercontent.com/Shicheng-Guo/Gscutility/master/ibdqc.pl

# rebuild plink file to avoid chromsome-miss-order problem
plink --bfile hapmap_r23a --make-bed --out hapmap_r23a.tab

# space to tab to generate bed files for liftOver from hg18 to hg19
plink --bfile hapmap_r23a.sort --recode tab --out hapmap_r23a.tab

# apply liftOverPlink.py to update hg18 to hg19 or hg38
./liftOverPlink.py -m hapmap_r23a.tab.map -p  hapmap_r23a.tab.ped -o hapmap_r23a.hg19 -c hg18ToHg19.over.chain.gz -e ./liftOver
./liftOverPlink.py -m hapmap_r23a.tab.map -p  hapmap_r23a.tab.ped -o hapmap_r23a.hg38 -c hg19ToHg38.over.chain.gz -e ./liftOver

# update plink to binary mode
plink --file hapmap_r23a.hg19 --make-bed --allow-extra-chr --out hapmap2.hg19
plink --file hapmap_r23a.hg38 --make-bed --allow-extra-chr --out hapmap2.hg38

# hapmap3 data cleaning and filtering
plink --bfile hapmap2.hg19 --missing
plink --bfile hapmap2.hg19 --maf 0.01 --make-bed --indep 50 5 2
plink2 --bfile hapmap2.hg19 --king-cutoff 0.125
plink2 --bfile hapmap2.hg19 --remove plink2.king.cutoff.out.id --make-bed -out hapmap2.hg19.deking
plink --bfile  hapmap2.hg19.deking --check-sex
