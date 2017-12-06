#!/usr/bin/perl

# Retira todos os sítios nas extreminades do alinhamento fasta sequencial dado em $ARGV[0] que possuam uma proporção de gaps superior a $ARGV[1] (dado em %), além dos sítios no interior do alinhamento que possuam um npumero de non-gap characters inferior a $ARGV[2]


use strict;
use warnings;

my $data = $ARGV[0];
open IN, "<$data" or die("Could not open fasta alignment.");
if(!defined($ARGV[1])){
	die("Please, specify trimming threshold (max % of gaps at edge sites).")
}
if(!defined($ARGV[2])){
	die("Please, specify gap threshold (min number of non-gap characters at each 'middle' site).")
}

#parseia alinhamento
my @headers;
my @bases = [];
my @align;
foreach my $line(<IN>){
	chomp($line);
	if ($line =~ />.+/){
		push(@headers,$line);
	}
	else{
		@bases = split("",$line);
		@align = (@align,[@bases]);
	}
}
close IN;

#define limite final
my $trimthresh = ($ARGV[1]/100)*scalar(@align);
my $gapthresh = $ARGV[2];

my $endcut;
for(my $i=scalar(@bases)-1;$i>=0;$i--){
	my $gap = 0;
	for(my $j=0;$j<scalar(@align);$j++){
		if($align[$j][$i] eq "-"){
			$gap++;
		}
	}
	if($gap<=$trimthresh){
		$endcut=$i;
		last;
	}
}

#define limite inicial e quais sítios serão selecionados
my $startcut;
my @slctsites;
my $mid = 0;
my $blkbrk = 1;
my $inblock = 0;
my $gappymidsites = 0;
for(my $i=0;$i<=$endcut;$i++){
	my $gap = 0;
	for(my $j=0;$j<scalar(@align);$j++){
		if($align[$j][$i] eq "-"){
			$gap++;
		}
	}
	if($mid==0 && $gap<=$trimthresh){
		$startcut = $i;
		$mid = 1;
	}
	if($mid==1){
		if((scalar(@align)-$gap)>=$gapthresh){
			push(@slctsites,$i);
			if($blkbrk==1){
				$blkbrk=0;
				$inblock++;	
			}
		}
		else{
			$gappymidsites++;
			$blkbrk=1;
		}
	}
}

#reescreve alinhamento com os sitios selecionados
open OUT, ">$data-zb";
for(my $i=0;$i<scalar(@align);$i++){
	print OUT $headers[$i]."\n";
	foreach(@slctsites){
		print OUT $align[$i][$_];
	}
	print OUT "\n";
}

my $slice = eval sprintf("%.2f",((scalar(@slctsites)/scalar(@bases))*100));
print "\n$data\n\n".scalar(@slctsites)." sites ($slice% in $inblock block(s)) selected out of ".scalar(@bases)." original sites:\n\t-".($startcut)." sites trimmed left\n\t-$gappymidsites middle 'gappy sites' deleted\n\t-".(scalar(@bases)-($endcut+1))." sites trimmed right\n\n";

exit;