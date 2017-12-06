#!/usr/bin/perl

# Retira gap-only sites do alinhamento phylip sequential dado em $ARGV[0]

use strict;
use warnings;

my $input = $ARGV[0];
open IN, "<$input";

my @headers;
my @seq = [];
my @align;
my $physize = <IN>;
foreach my $line(<IN>){
	chomp($line);
	if ($line =~ /(.+\h)([A-Za-z-]+)/){
		push(@headers,$1);
		@seq = split("",$2);
		@align = (@align,[@seq]);
	}
}
close IN;

my @infSiteIndexes;
my $count = 0;
for(my $i=0;$i<scalar(@seq);$i++){
	my $gap = 0;
	for(my $j=0;$j<scalar(@align);$j++){
		if($align[$j][$i] eq "-"){
			$gap++;
		}
	}
	if ($gap < scalar(@align)){
		$infSiteIndexes[$count] = $i;
		$count++;
	}
}

my @physize = split(/\h/,$physize);
print $physize[0]." ".scalar(@infSiteIndexes)."\n";
for(my $j=0;$j<scalar(@align);$j++){
	print $headers[$j];
	foreach my $site(@infSiteIndexes){
		print $align[$j][$site];
	}
	print "\n";
}

exit;