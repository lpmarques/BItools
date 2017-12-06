#!/usr/bin/perl

#redução do script sum-meanBL.pl para calcular o comprimento total de uma árvore dada em ARGV[0]

use strict;
use warnings;

my $tree = $ARGV[0];
open IN, "$tree";

my @edges = split(":", <IN>);
my $blsum = 0;
foreach(@edges){
    if(/(\d.\d+)/){
        $blsum = $blsum+$1;
    }
}
print $blsum."\n";

exit;