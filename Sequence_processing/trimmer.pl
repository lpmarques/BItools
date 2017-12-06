#!/usr/bin/perl

# Retira todas as posições nas extreminades do alinhamento fasta (sequencial ou interleaved) dado em $ARGV[0] que possuam uma proporção de gaps superior a $ARGV[1] (dada em %).

use strict;
use warnings;

my $data = $ARGV[0];
open IN, "<$data" or die("Could not open fasta alignment.");
if(!defined($ARGV[1])){
	die("Please, specify trimming threshold (max % of gaps at edge sites).")
}

#parseia alinhamento
my @headers;
my @seq;
my @align;
while (my $line = <IN>){
	chomp($line);
	if ($line =~ />.+/){
		push(@headers,$line);
		if(scalar(@headers)>1){
			@align = (@align,[@seq]);
			@seq = ();
		}
	}
	else{
		push(@seq,split("",$line));
	}
}
@align = (@align,[@seq]);
close IN;

#define limite final
my $threshold = ($ARGV[1]/100)*scalar(@align);

my $endcut;
for(my $i=scalar(@seq)-1;$i>=0;$i--){
	my $gap = 0;
	for(my $j=0;$j<scalar(@align);$j++){
		if($align[$j][$i] eq "-"){
			$gap++;
		}
	}
	if($gap<=$threshold){
		$endcut=$i;
		last;
	}
	if($i==0){
		die "There is no site in this alignment with gap proportion below the trimming threshold specified.\n";
	}
}

#define limite inicial e escreve alinhamento trimado
my $startcut;
for(my $i=0;$i<=$endcut;$i++){
	my $gap = 0;
	for(my $j=0;$j<scalar(@align);$j++){
		if($align[$j][$i] eq "-"){
			$gap++;
		}
	}
	if($gap<=$threshold){
		$startcut=$i;
		open OUT, ">$data.trimmed";
		for(my $y=0;$y<scalar(@align);$y++){
			print OUT $headers[$y]."\n";
			for(my $z=$startcut;$z<=$endcut;$z++){
				print OUT $align[$y][$z];
			}
			print OUT "\n";
		}
		close OUT;
		last;
	}
}


exit;