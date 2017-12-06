#!usr/bin/perl

#a partir de um fasta recebido em $ARGV[0], gera um novo fasta apenas com as sequencias cujos headers apresentem um dos taxons presentes numa lista dada em $ARGV[1] (nome exato, com epiteto genérico e específico)
#alternativamente, no lugar da lista de taxons, também pode ser dada uma lista com numeros de acesso ou qualquer outro localizador (qualquer match será incluído no novo fasta)

use warnings;
use strict;

my $fasta = $ARGV[0];
my $taxlist = $ARGV[1];

open IN, "<$taxlist";
my @taxons;
while (my $line = <IN>){
	chomp($line);
	push(@taxons,$line);
}
close IN;

my @headers;
my %fasta = ();
my $header = "";
open IN, "<$fasta";
while (my $line = <IN>){
	chomp($line);
	if ($line =~ /^>/){
		$header = $line;
		push(@headers,$header);
	}
	else{
		$fasta{$header} .= $line;
	}
}
close IN;

if($fasta =~ /(.+)\..+/){
	open OUT, ">$1.selection";
}
foreach my $header(@headers){
	foreach my $taxon(@taxons){
		if ($header =~ /$taxon/){
			print OUT $header."\n".$fasta{$header}."\n";
		}
	}
}
close OUT;

exit;