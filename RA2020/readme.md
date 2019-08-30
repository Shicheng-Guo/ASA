merge 1st and 2nd plink files and upload to michigen
```
plink --file RA56 --merge RA57.ped RA57.map --recode --make-bed --out RA113
plink --bfile RA113 --bmerge he2019.bed he2019.bim he2019.fam --recode --make-bed --out RA2020
```
