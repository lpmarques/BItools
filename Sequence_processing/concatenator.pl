#!/usr/bin/perl

#Concatena todos os alinhamentos fasta (interleaved ou não) no diretório, criando fasta único (não interleaved), além 
#de outro arquivo opcional com as partições (nomes dos alinhamentos individuais e seus respectivos limites no concatenado).

use warnings;
use strict;

#captura lista (@ls) dos arquivos fasta com a extensão informada no diretório, armazenando cada sequencia de cada fasta em uma hash (%fastas), com as chaves $fasta (nome do arquivo) e $header (headers das sequencias em cada arquivo)
#e armazena todos os headers únicos nos fastas em um array (@refheaders) a ser utilizado como referência durante o concatenamento
print "\nQual é a extensao dos alinhamentos fasta neste diretorio que deseja concatenar? (fst,fasta,fa,etc)\n";
chomp(my $answ0 = <STDIN>);
print "\n";
my @ls = glob "*.$answ0";
my $counter = 0;
my @refheaders;
my %fastas = ();
foreach my $fasta (@ls){
	chomp($fasta);
	my $header = "";
	open IN, "<$fasta";
	print "Lendo alinhamento $fasta\n";
	$counter++;
	while(my $line = <IN>){
		my $headmatch = 0;
		chomp($line);
		if ($line =~ />/){
			$header = $line;
			foreach(@refheaders){
				if($_ eq $header){
					$headmatch++;
					last;
				}
			}
			if($headmatch==0){
				push(@refheaders,$header);
			}
		}
		else{
			$line =~ s/\h//g;
			$fastas{$fasta}{$header} .= $line;
		}
	}
	close IN;
}

#concatena todos os fasta armazenados em %fastas em uma nova hash (%concat), segundo a referência %refheaders
my %concat = ();
print "\nComo preencher sequencias não representadas? (-/?/N)\n";
chomp(my $answ1 = <STDIN>);
print "\nConcatenando $counter alinhamentos...\n";
foreach my $fasta (sort keys %fastas){
	foreach my $refheader(@refheaders){
		my $seq = "";
		my $seqlen = 0;
		my $headmatch = 0;
		foreach my $header (sort keys $fastas{$fasta}){
			$seq = $fastas{$fasta}{$header};
			$seqlen = length($fastas{$fasta}{$header});
			if ($header eq $refheader){
				$headmatch++;
				$concat{$refheader} .= $fastas{$fasta}{$header}
			}
		}
		#preenche os espaços referentes a sequencias ausentes em cada alinhamento, com indels (ou missing data [?/N]) de comprimento compatível
		if ($headmatch == 0){
			for (my $i=0;$i<$seqlen;$i++){
				$concat{$refheader} .= "$answ1";
			}
		}
	}
}

#imprime o concatenado com headers em ordem alfabética ou não, segundo preferência declarada, em arquivo de nome escolhido
print "\nComo deseja nomear fasta do concatenamento? (inclua extensao)\n";
chomp(my $answ2 = <STDIN>);
print "\nOrganizar sequencias em ordem alfabética? (s/n)\n";
REPEAT:
chomp(my $answ3 = <STDIN>);
open OUT, ">$answ2";
if ($answ3 =~ /[Ss](im)?/){
	foreach (sort keys %concat){
		print OUT "$_\n$concat{$_}\n";
	}	
}
elsif ($answ3 =~ /[Nn](ao)?/){
	foreach (keys %concat){
		print OUT "$_\n$concat{$_}\n";
	}	
}
else{
	print "\nNao entendi. Repita a resposta por favor:\n";
	goto REPEAT;
}
close OUT;

#imprime, separadamente, lista com os limites de cada alinhamento original no novo arquivo concatenado 
print "\n===============================================================\n\nDeseja imprimir partições? (s/n)\n";
chomp(my $answ4 = <STDIN>);
if ($answ4 =~ /[Ss](im)?/){
	print "\nNome (com extensao):\n";
	chomp(my $answ5 = <STDIN>);
	open OUT, ">$answ5";
	my $maxlim = 0;
	foreach my $fasta (sort keys %fastas){
		foreach my $header (sort keys %{$fastas{$fasta}}){
			my $minlim = $maxlim+1;
			$maxlim = $maxlim + length($fastas{$fasta}{$header});
			print OUT $fasta." = ".$minlim."-".$maxlim."\n";
			last;
		}
	}
	close OUT;
}
print "\n\n";

exit;