#!usr/bin/perl

use strict;
use warnings;

#abre arquivo com multiplos blocos gb
my $multi_gb = shift;
open IN, "<$multi_gb";

$/ = "//";
my %gbs;
while (my $gb = <IN>){ #de cada bloco gb
	chomp($gb);
	#obtem n de acesso, especie, extensao do cds, nome do gene e sequencia do gene
	if($gb =~ /ACCESSION\h+(\w+).+ORGANISM\h+([A-Z][a-z]+\h[a-z]+).+CDS\h+(.+?)\/gene="(\w+)".+ORIGIN\h+(.+)/s){
		my $id = $1;
		my $sp = $2;
		my $cds_range = $3;
		my $gene = $4;
		my $seq = $5;
		$sp =~ s/\h/_/;
		$seq =~ s/[\s\d]//g;
		$cds_range =~ s/\s//g;
		my @seq_bases = split("",$seq);
		#monta cds com a(s) parte(s) da sequencia indicada(s) em $cds_range
		my @cds_bases;
		if($cds_range =~ /((\d+\.\.\d+,?)+)/){
			my @range = split(",",$1);
			foreach my $slice(@range){
				if($slice =~ /(\d+)\.\.(\d+)/){
					push(@cds_bases,@seq_bases[$1-1..$2-1]);
				}
			}
		}
		my $cds = join("",@cds_bases);
		#armazena cds, identificada pelo nome do gene, da especie e n de acesso proprio
		$gbs{$gene}{$sp}{$id} = $cds;
	}
}
close IN;

#seleciona maior cds de cada gene para cada especie e adiciona a um arquivo fasta com o nome do gene
foreach my $gene(keys(%gbs)){
	open OUT, ">$gene.fasta";
	foreach my $sp(keys($gbs{$gene})){
		my $id_maior_cds;
		foreach my $id(keys($gbs{$gene}{$sp})){
			if(!defined($id_maior_cds)){
				$id_maior_cds = $id;
			}
			elsif(length($gbs{$gene}{$sp}{$id_maior_cds}) < length($gbs{$gene}{$sp}{$id})){
				$id_maior_cds = $id;
			}
		}
		print OUT ">".$sp."_".$gene."_".$id_maior_cds."\n".$gbs{$gene}{$sp}{$id_maior_cds}."\n";
	}
	close OUT;
}

exit;