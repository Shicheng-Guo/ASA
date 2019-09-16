open F,shift @ARGV;
while(<F>){
chomp;
my @line=split /\s+/,$_;
if($line[1]=~/A/){
$line[5]=2;
}else{
$line[5]=1;
}
my $out=join("\t",@line);
print "$out\n";
}
