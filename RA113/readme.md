

```
cd ~/hpc/rheumatology/RA/he2019/plink/vcf
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
echo bcftools view RA113.chr$i.vcf -Oz -o RA113.chr$i.vcf.gz >>$i.job
echo tabix -f -p vcf RA113.chr$i.vcf.gz >> $i.job
qsub $i.job
done
```


```
 wget https://imputationserver.sph.umich.edu/share/results/bef4440e3b1075b1e36132516faa3ef3/chr_1.zip
 wget https://imputationserver.sph.umich.edu/share/results/1336b8967d31c223a569adf29412caa4/chr_10.zip
 wget https://imputationserver.sph.umich.edu/share/results/91c6e45418f942d69073e281cf3c5904/chr_11.zip
 wget https://imputationserver.sph.umich.edu/share/results/35920d77b5210b944ab61e218e73972c/chr_12.zip
 wget https://imputationserver.sph.umich.edu/share/results/64faf60dec19e796a254b8e5e4376e3d/chr_13.zip
 wget https://imputationserver.sph.umich.edu/share/results/7b6243c571ed0296769241a47ae74ed/chr_14.zip
 wget https://imputationserver.sph.umich.edu/share/results/99cd67c29c8b3fe19ff5f18806909d71/chr_15.zip
 wget https://imputationserver.sph.umich.edu/share/results/95d6d2dc584325fa929b999a6354a0e1/chr_16.zip
 wget https://imputationserver.sph.umich.edu/share/results/d8fa74efe670d6c065df3e80f78b282f/chr_17.zip
 wget https://imputationserver.sph.umich.edu/share/results/6f8fd584e0811bcc63986414a4c41328/chr_18.zip
 wget https://imputationserver.sph.umich.edu/share/results/21fe31b051d2db6af92033b118d5cbe/chr_19.zip
 wget https://imputationserver.sph.umich.edu/share/results/c30b986014f813fbdaab8be6264803e0/chr_2.zip
 wget https://imputationserver.sph.umich.edu/share/results/e213c4bd06a8f7e8d7fc2afaf18b56a9/chr_20.zip
 wget https://imputationserver.sph.umich.edu/share/results/95908a009e3e59bf7ea642f65fb920c7/chr_21.zip
 wget https://imputationserver.sph.umich.edu/share/results/f0eae19cf181a38ecf9938733b2c08d7/chr_22.zip
 wget https://imputationserver.sph.umich.edu/share/results/d6645b933656c261046390e6bb5f9696/chr_3.zip
 wget https://imputationserver.sph.umich.edu/share/results/a9221a9b2ec5b5d6f1b791e6e9450cc5/chr_4.zip
 wget https://imputationserver.sph.umich.edu/share/results/bd4f613061782d49115de51570019fe1/chr_5.zip
 wget https://imputationserver.sph.umich.edu/share/results/e5681641a2ed8f2010dd1c2a767d8d2f/chr_6.zip
 wget https://imputationserver.sph.umich.edu/share/results/468e27dea2d50fec15d06440a6ade64d/chr_7.zip
 wget https://imputationserver.sph.umich.edu/share/results/f6b602737cd162c836b94bc52f51503e/chr_8.zip
 wget https://imputationserver.sph.umich.edu/share/results/d6231c89c5a760226aab316cc3b14ddd/chr_9.zip
```
