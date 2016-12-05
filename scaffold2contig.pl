#!/usr/bin/perl
use strict;
#modified from http://seqanswers.com/forums/showthread.php?t=12993

#Usage  perl scaffold2contig.pl <fasta seq> <integer>

my $file = $ARGV[0];
my $number =$ARGV[1];
open(IN,$file) || die "Incorrect file $file. Exiting...\n";

my ($seq, $name)=('','');
while(<IN>){
  chomp;
  my $line = $_;
  $seq.= uc($line) if(eof(IN));
  if (/\>(\S+)/ || eof(IN)){
    if($seq ne ''){
#change number 1 to the number of N's you want to split by. Ex. "my @seqgaps = split(/[N]{10,}/, $seq); "
      my @seqgaps = split(/[N]{$number,}/, $seq);
      if($#seqgaps > 0){
        my $ctgcount=0;
        foreach my $ctgseq (@seqgaps){
          $ctgcount++;
          print "$name contig$ctgcount (size=".length($ctgseq).")\n$ctgseq\n";
        }
      }else{
        print ">$name\n$seq\n";
      }
    }
    $seq='';
    $name = $_;
  }else{
    $seq.=uc($line);
  }
}

