#!/usr/bin/perl

# redução do script alignreader.pl para calculo da proporcao de gaps em um alinhamento dado em $ARGV[0] (le alinhamentos phylip sequential ou fasta)

use strict;
use warnings;

my $input = $ARGV[0];
open IN, "<$input" or die;

my $seqcount = 0;
my @seq;
my $gap = 0;
if(<IN> =~ /\d+\h(\d+)\n/){
	my $len = $1;
	foreach my $line(<IN>){
		chomp($line);
		if ($line =~ /.+\h([A-Z-]{$len})/){
			$seqcount++;
			@seq = split("",$1);
			foreach my $base (@seq){
				if($base eq "-"){
					$gap++;
				}
			}
		}
	}
}
else{
	foreach my $line(<IN>){
		chomp($line);
		if ($line !~ />.+/){
			$seqcount++;
			@seq = split("",$line);
			foreach my $base (@seq){
				if($base eq "-"){
					$gap++;
				}
			}
		}
	}
}
close IN;

my $length = scalar(@seq);
my $gapProp = eval sprintf('%.6f',$gap/($length*$seqcount));
print $gapProp;

exit;