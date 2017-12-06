#!usr/bin/perl

#Identifica e converte qualquer alinhamento dado, de formato fasta, para phylip relaxado ou de phylip relaxado para fasta.

use warnings;
use strict;

my $align = $ARGV[0];

my $text;
if ($align =~ /(.+)?(\..+)$/){
	$text = $1;
}
my $seqlength = 0;
my $seqcount = 0;
my $header = "";
my %align = ();
my @seq_order;

open IN, "<$align";
my $line = <IN>;
if ($line =~ /\d+\h+\d+/){
	foreach my $line (<IN>){
		chomp($line);
		if ($line =~ /(.+)\h+([A-Z-]+)/i){
			$header = $1;
			$align{$header} .= $2;
			$seq_order[$seqcount] = $header;
			$seqcount++;
		}
	}
	open OUT, ">$text.fasta";
	foreach(@seq_order){
		print OUT ">$_\n$align{$_}\n";
	}
	close OUT;
}
else{
	seek(IN,-length($line),1);
	foreach my $line (<IN>){
		chomp($line);
		$line =~ s/\h//g;
		if ($line =~ />(.+)/){
			$header = $1;
			$seq_order[$seqcount] = $header;
			$seqcount++;
		}
		else{
			$align{$header} .= $line;
		}
		$seqlength = length($align{$header});
	}
	open OUT, ">$text.phy";
	print OUT " $seqcount $seqlength\n";
	foreach(@seq_order){
		print OUT "$_ $align{$_}\n";
	}
	close OUT;
}
close IN;

exit;