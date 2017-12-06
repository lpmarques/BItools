#!/usr/bin/perl

use strict;
use warnings;

sub unroot{ ## Desenraiza árvore em formato newick!
	chomp($_[0]);
	my $t = $_[0]; # recebe newick
	substr($t,0,1) = ""; # e retira parenteses mais externos
	substr($t,-2,1) = "";
	my $sep = "";
	$t =~ /\:/ ? $sep = ":" : $t =~ s/(\w+|\))/$1:/g; # se a árvore não tiver comprimentos de ramo, introduz ":" onde haveria se tivesse
	my @tree = split(":",$t); # divide a árvore entre os ":"
	my (@subtrees,@edges,$st);
	my $o = 0;
	for(my $i=0; $i<scalar(@tree)-1; $i++){ # para cada fragmento resultante...
		$st .= "$tree[$i]$sep"; # o concatena à subtree atual
		if($tree[$i] =~ /(\(+)/){
			$o += length($1); # adiciona à contagem de clados abertos
		}
		elsif($tree[$i] =~ /\)+/){
			$o--; # ou reduz da contagem
		}
		if($o==0){ # se a contagem for zero
			$st =~ s/:$//; # fecha a subtree atual
			push(@subtrees,$st); # e a adiciona à lista de subtrees
			my @node = split(/,|;/,$tree[$i+1]); # do fragmento seguinte, acessa o comprimento de ramo interno que separa a subtree do restante da árvore
			push(@edges,$node[0]); # e o adiciona à lista de ramos internos entre subtrees
			$tree[$i+1] = $node[1] if defined($node[1]); # apaga o ramo do fragmento seguinte
			$st = undef; # reseta a subtree
		}
	}
	if(scalar(@subtrees)==2){ # se foi possível dividir a árvore em um mínimo de 2 subtrees (ou seja, está enraizada),
		for(my $i=0;$i<=1;$i++){ # entre as subtrees...
			if($subtrees[$i] =~ /\(.+\)/){ # localiza uma que contenha mais de um táxon
				$subtrees[$i] = substr($subtrees[$i],1,length($subtrees[$i])-2); # e retira seus parenteses mais externos, quebrando-a em duas
				if($sep eq ":"){ # se a árvore original contém comprimentos de ramo,
					my $newedge = $edges[0]+$edges[1]; # a soma dos ramos que separavam as duas subtrees originais
					$subtrees[$i-1] .= "$sep$newedge"; # torna-se o comprimento de ramo da subtree que permaneceu intacta
				}
				return("(".join(",",@subtrees).");"); # retorna a nova árvore redutível a um mínimo de 3 subtrees (desenraizada)
			}
		}
	}
	elsif(scalar(@subtrees)>2){ # se a árvore já era redutível a um mínimo de mais de 2 subtrees (ou seja, já estava sem raiz),
		return($_[0]); # retorna a árvore de input
	}
	else{
		die("Tree '$_[0]' is malformed; unable to unroot it.\n");
	}
}

