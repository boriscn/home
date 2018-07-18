#!usr/bin/perl
#author: Boris
#2017-7-17
#execute perl script as below:
#$perl <perl script name> <*out.aic>
open (OUTAIC,"<".$ARGV[0]) or die "can not open out.aic file!\n";
my @keys;
my @values;
foreach(<OUTAIC>)
{
if ($_=~/.*"wavetable\s+(\d+)".*{\s+\w+\s+(\w+)\s+\d+\s+};/)
{
push(@keys,$1);
push(@values,$2);
}
}

my $out_tim=$ARGV[0];
   $out_tim=~s/aic/tim/;
open (OUTTIM,"<".$out_tim);
open (TEMP,">_".$out_tim);
foreach(<OUTTIM>)
{
my $i;
for($i=0;$i<@keys;$i++)
{
$_=~s/wavetable\s+$keys[$i]/$values[$i]/;
$_=~s/equation\s+set\s+$keys[$i]/$values[$i]/;
}
print TEMP $_;
}
close OUTTIM;
close TEMP;

&word_counts("_".$out_tim);

#word counts function
sub word_counts
{
my $input_file=$_[0];
open (my $fh,"<$input_file");
open (OUT,">m".$input_file);
my $con=join('',<$fh>);
my $wc;
my @wcs;
while($con=~/(9\d{9})(.*?@)/sg)
{
$wc=length($2)+9000000000;
push(@wcs,$wc);
}

open (my $fh,"<$input_file");
my $k=0;
foreach(<$fh>)
{
if ($_=~/9\d{9}/)
{
$_=~s/9\d{9}/$wcs[$k]/;
$k++;
}
print  OUT $_;
}
close OUT;
close $fh;
}

unlink "_".$out_tim;
