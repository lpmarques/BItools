#!/usr/bin/perl

use strict;
use warnings;

sub treeDist{ ## Dá a distância topológica entre duas árvores newick não enraizadas, pela métrica de partição (sensível apenas a topologia) ou BSD (sensível também a comprimentos de ramo)
	my $lensense = defined($_[2]) ? pop : 0; ## 0 - Partition Metric (Penny & Hendy, 1985 [or Robindon & Foulds, 1981, originally]) =default= | 1 - Branch Score Distance (Kuhner & Felsenstein, 1994)
	my $i;
	my %parts;
	foreach my $t(@_){
		$i++;
		chomp($t);
		my $bl = 0;
		$t =~ /\:/ ? $bl = 1 : $t =~ s/(\w+|\))/$1:/g;
		die("Trees '$_[0]' and '$_[1]' are not comparable: BSD metric not valid for lengthless trees (try default option 0 - Penny & Handy's Partition Metric)") if !$bl && $lensense;
		my @tree = split(":",$t);
		my ($c,$cci) = 0; # counter of clades and current clade index 
		my (@taxa,@term_bls,@clades,@int_bls,@ocis); # taxa, terminal branch lengths, clades, internal branch lengths and open clades index
		foreach my $slice(@tree){
			if($slice =~ /(\d\.?\d*)?(\))?,?(\(+)?(\w+)?/){
				if(defined($1)){
					!defined($cci) || $cci == $ocis[-1] ? push(@term_bls,$1) : do {$int_bls[$cci] = $1;$cci = $ocis[-1]};
				}
				if(defined($4)){
					push(@taxa,$4);
					do {$cci = $c+length($3)-1;push(@ocis,($c..$cci));@clades[$c..$cci] = [()];$c+=length($3)} if defined($3);
					foreach(@ocis){
						push(@{$clades[$_]},$4);
					}
				}
				elsif(defined($2)){
					pop(@ocis);
					$clades[$cci] = [sort(@{$clades[$cci]})]; 
					$cci = $ocis[-1] if !$bl;
				}
			}
		}
		shift(@clades);
		shift(@int_bls);

		my ($j,$k,$l);
		my $ntaxa = scalar(@taxa);
		my $nclades = scalar(@clades);
		for($j=0;$j<$nclades;$j++){
			my $cntaxa = scalar(@{$clades[$j]});
			if($cntaxa>$ntaxa/2){
				my @temp;
				for($k=0;$k<$ntaxa;$k++){
					for($l=0;$l<$cntaxa;$l++){
						last if $taxa[$k] eq $clades[$j][$l];
					}
					push(@temp,$taxa[$k]) if $l==$cntaxa;
				}
				$clades[$j] = join(",",sort(@temp));
			}
			else{
				$clades[$j] = join(",",@{$clades[$j]});
			}
			$parts{"t$i"}{$clades[$j]} = $bl ? $int_bls[$j] : 0; # stores each internal branch partition (id: list of taxon names in smaller subtree)

		}
		for($j=0;$j<$ntaxa;$j++){
			$parts{"t$i"}{$taxa[$j]} = $bl ? $term_bls[$j] : 0; # stores each terminal branch partitions (id: taxon name)
		}

	}
	my $ntaxa = scalar(keys(%{$parts{t1}}));
	die("Trees '$_[0]' and '$_[1]' are not comparable: different sets of taxa.\n") if $ntaxa != scalar(keys(%{$parts{t2}}));

	my $PD = 0;
	my @t = ("t1","t2");
	for(my $i=0; $i<2; $i++){
		foreach(keys(%{$parts{$t[$i]}})){
			if(exists($parts{$t[$i-1]}{$_})){ # checks if partitions are shared by both trees
				do {$PD += ($parts{$t[$i]}{$_}-$parts{$t[$i-1]}{$_})**2;$parts{$t[$i]}{$_} = 0;$parts{$t[$i-1]}{$_} = 0} if $lensense;
			}
			else{
				die("Trees '$_[0]' and '$_[1]' are not comparable: different sets of taxa.\n") if $_ !~ /,/;
				$PD += $lensense ? $parts{$t[$i]}{$_}**2 : 1;
			}
		}
	}
	$lensense ? return(sqrt($PD)) : $PD;
}
