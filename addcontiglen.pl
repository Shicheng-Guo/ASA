open F,"hg19.contig.txt" || die print "hg19.contig.txt";
my %len;
while(<F>){
chomp;
if(/ID=(\d+),/){
$len{$1}=$_;
}
}
close F;

foreach my $chr(1..22){
open F1,"chr$chr.dose.filter.header" || die "Could not open file 'chr$i.dose.filter.header'. $!";
open OUT, ">chr$chr.dose.filter.newheader";
while(<F1>){
if(/ID\=$chr/){
print OUT "$len{$chr}\n";
}else{
print OUT  $_;
}
}
close F1;
}
