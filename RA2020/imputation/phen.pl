
open DB,"/gpfs/home/guosa/hpc/rheumatology/RA/he2020/RA2020-B8.dbsnp.fam";
my %db;
while(<DB>){
my @line=split/\s+/;
$db{$line[1]}=$_;
}
close DB;
open F, shift @ARGV;
while(<F>){
chomp;
my @line=split /\s+/,$_;
print $db{$line[1]};
}
