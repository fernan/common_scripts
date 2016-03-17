use strict;
use warnings;

#taken from https://www.biostars.org/p/90333/
#By https://www.biostars.org/u/7002/ Kenosis 
#Usage: perl script.pl foo.fa annotations.txt [>outFile.fa]
#
my $file1 = shift;
my ( %hash, @F );

while (<>) {
    $hash{ $F[0] } = $F[1] if @F = split;
}

local $/ = '>';
push @ARGV, $file1;

while (<>) {
    print ">$F[0] $hash{ $F[0] }\n$F[1]\n" if @F = split />|\n/ and $hash{ $F[0] };
}
