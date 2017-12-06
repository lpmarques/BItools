#!/usr/bin/perl

use strict;
use warnings;

sub treeDist{ ## Dá a distância topológica entre duas árvores newick não enraizadas, pela métrica de partição (sensível apenas a topologia) ou BSD (sensível também a comprimentos de ramo)
	my $lensense = scalar(@_)==3 ? pop : 0; ## 0 - Partition Metric (Penny & Hendy, 1985) =default= | 1 - Branch Score Distance (Kuhner & Felsenstein, 1994)
	my %phys;
	my $i;
	foreach my $t(@_){ # dada cada árvore...
		$i++;
		chomp($t);
		my $bl = 0;
		$t =~ /\:/ ? $bl = 1 : $t =~ s/(\w+|\))/$1:/g; # se a árvore não tiver comprimentos de ramo, introduz ":" onde haveria se tivesse
		die("Trees '$_[0]' and '$_[1]' are not comparable: BSD metric not valid for lengthless trees (try default option 0 - Penny & Handy's Partition Metric)") if $bl==0 && $lensense==1;
		my @tree = split(":",$t); # divide a árvore entre os ":"
		my ($c,$cc) = 0;
		my (@taxa,@term_bls,@clades,@int_bls,@ocs);
		foreach my $part(@tree){ # em cada fragmento resultante...
			if($part =~ /(\d\.?\d*)?(\))?,?(\(+)?(\w+)?/){
				if(defined($1)){ # se houver tamanho de ramo,
					if(!defined($cc) || $cc == $ocs[-1]){ # e o clado atual não tiver acabado de ser fechado,
						push(@term_bls,$1); # armazena como ramo terminal que separa o último táxon do restante da árvore
					}
					else{ # do contrário,
						$int_bls[$cc] = $1; # armazena como ramo interno que separa o clado atual do restante da árvore
						$cc = $ocs[-1]; # o último clado aberto e ainda não fechado passa a ser o clado atual
					}
				}
				if(defined($4)){ # se houver taxon,
					push(@taxa,$4); # o adiciona à lista de taxons
					if(defined($3)){ # e se houver abertura(s) de clado,
						$cc = $c+length($3)-1; # o índice do clado atual ($cc) passa a corresponder ao último aberto
						push(@ocs,($c..$cc)); # o(s) índice(s) do(s) novo(s) clado(s) aberto(s) entra(m) para a lista de índices de clados abertos (@ocs)
						@clades[$c..$cc] = [()]; # a lista de clados recebe lista(s) de taxon(s) vazia(s)
						$c+=length($3); # soma o número de novos clados abertos à contagem de clados
					}
					foreach(@ocs){ # a cada clado ainda aberto...
						push(@{$clades[$_]},$4); # adiciona o novo taxon à lista de taxons do clado
					}
				}
				elsif(defined($2)){ # se houver fechadura de clado,
					pop(@ocs); # exclui o clado atual da lista de clados abertos
					$clades[$cc] = join(",",sort(@{$clades[$cc]}));
					$cc = $ocs[-1] if $bl == 0;
				}
			}		
		}
		shift(@clades); # ignora primeiro clado (que contém todos os taxons)
		shift(@int_bls);
		for(my $j=0;$j<scalar(@taxa);$j++){ # armazena todas as partições (representadas pelos taxons e clados da árvore) em uma hash
			$phys{$i}{$taxa[$j]} = shift @term_bls;
		}
		for(my $j=0;$j<scalar(@clades);$j++){
			$phys{$i}{$clades[$j]} = shift @int_bls;
		}
	}
	my $PD = 0; # calcula diferenças entre partições nas duas árvores, como medida pela métrica requisitada
	my @t = (1,2);
	for(my $i=0; $i<2; $i++){
		foreach(keys($phys{$t[$i]})){
			if(exists($phys{$t[$i-1]}{$_})){
				if($lensense == 1){
					$PD += ($phys{$t[$i]}{$_}-$phys{$t[$i-1]}{$_})**2;
					$phys{$t[$i]}{$_} = 0;
					$phys{$t[$i-1]}{$_} = 0;
				}
			}
			else{
				die("Trees '$_[0]' and '$_[1]' are not comparable: different sets of taxa.\n") if $_ !~ /,/;
				$PD += $lensense == 1 ? $phys{$t[$i]}{$_}**2 : 1;
			}
		}
	}
	return($PD); # retorna a distância topológica
}
