#!/bin/perl

use strict;

my @Output = ();

my $old_sep = $/;
$/ = '>';

open (INPUT, $ARGV[0]) or die $!." $ARGV[0]";
while (<INPUT>)
  {
    next if (length $_ == 1);
    chomp;
    my @lines = split(/\n/);
    my $header = shift @lines;
    my $seq = join(//, @lines);
	print ">".$header."\n";
	foreach my $o (@lines)
  {
    print $o; 
  }
    print "\n";
	push (@Output, ">".$header);
    push (@Output, $seq);
  }
close INPUT;

# $/ = $old_sep;
# open (OUTPUT, "> $ARGV[0].new") or die $!." $ARGV[0].new";
# foreach my $o (@Output)
  # {
    # print OUTPUT $o."\n"; 
  # }

# close OUTPUT;
