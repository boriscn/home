#!usr/bin/perl
#anthor: Boris
#date: 29-6-2018
opendir (DIR,"./");
my @list1=readdir(DIR); 
closedir DIR;
my @list;
my $fh_in;
my $fh_out;
my @old_pins;
my @new_pins;
mkdir "output";
open (RENAME,"<rename_rule.txt");
foreach (<RENAME>)
{
$_=~s/^\s+//;
$_=~/\s+/;
push(@old_pins,$`);
push(@new_pins,$');
}
close RENAME;

foreach(@list1)
{
if ($_=~/\.pin|\.lvl|\.level|\.tim|\.binl/)
{
push(@list,$_);
}
}

my $i;
my $j;
my @list_lvl_tim;
for($i=0;$i<@list;$i++)
{
 chomp($list[$i]);
 if ($list[$i]=~/\.gz/) #for compressed pattern
 {
 system("gzip -d $list[$i]");
 $list[$i]=~s/\.gz//;
 }
 open ($fh_in,"<".$list[$i]) or die "can not open source file";
 
 if($list[$i]=~/\.lvl|\.level|\.tim/) #for tim and level
 {
  open ($fh_out,">./output/"."raw_".$list[$i]);  #cout the replaced but wrong wc file
  push(@list_lvl_tim,$list[$i]);
 }
 
 if($list[$i]=~/\.pin|\.binl/)
 {
  open ($fh_out,">./output/".$list[$i]);
 }
#rename the pin names
 foreach(<$fh_in>)
 {
  for ($j=0;$j<@old_pins;$j++)
  { 
   chomp($old_pins[$j]);
   chomp($new_pins[$j]);
   $_=~s/$old_pins[$j]/$new_pins[$j]/;
  }
    print $fh_out $_;  #the output file
 }

 close $fh_in;
 close $fh_out;
}


#words count block
my $fh1;
my $fh2;
my $line;
my @file;
for(my $jj=0;$jj<@list_lvl_tim;$jj++)
{
my $m=0;
my @wc;
open($fh1,"<".$list_lvl_tim[$jj]);
open($fh2,">./output/".$list_lvl_tim[$jj]);
   $line=join('',<$fh1>);
   @file=split("@",$line);
for(my $ii=0;$ii<@file;$ii++)
{

if($file[$ii]=~/#\d{10}/)
{
$file[$ii]=~s/(.*\n*)*.*#\d{10}//;  #remove anything before #9000000000
$file[$ii]=~s/$/@/;
$wc[$m]=length($file[$ii])+9000000000;
#print $m.":".$wc[$m]."\n";
$m++;
}
}

open($fh1,"<".$list_lvl_tim[$jj]);
my  @input=<$fh1>;
my $n;
my $match;
for ($n=0;$n<@input;$n++)
{
if($input[$n]=~/#9\d{9}/)
 {
  $input[$n]=~s/9\d{9}/$wc[$match]/;
  $match++;
 }
 
 print $fh2 $input[$n];
}


close $fh1;
close $fh2;
}


#delete the intermadiate "raw_" files
opendir (RAW,"./output/");
my @raws=readdir(RAW);
closedir RAW;
foreach(@raws)
{
if($_=~/^raw_/)
{unlink "./output/".$_;}
}




