#!/usr/bin/perl

#Lê cada um dos sitios ao longo de um alinhamento fasta declarado em $ARGV[0], gerando como output
# uma matriz tabulada com informações a respeito da proporção de bases e gaps em cada sítio do alinhamento.

use strict;
use warnings;

my $input = $ARGV[0];
open IN, "<$input";

my @seq;
my @align;
foreach my $line(<IN>){
	chomp($line);
	if ($line !~ />.+/){
		@seq = split("",$line);
		push(@align,[@seq]);
	}
}
close IN;

print "Site\tGap_prop\tA_prop\tC_prop\tG_prop\tT_prop\tPyr_prop\tPur_prop\tStr_prop\tWk_prop\tNX_prop\tOther\n";
for(my $i=0;$i<scalar(@seq);$i++){
	my ($G, $C, $A, $T, $gap, $strong, $weak, $purine, $pyrimidine, $noID, $other) = (0) x 11;
	for(my $j=0;$j<scalar(@align);$j++){
		if($align[$j][$i] eq "G"){
			$G++;
			$purine++;
			$strong++;
		}
		elsif($align[$j][$i] eq "C"){
			$C++;
			$pyrimidine++;
			$strong++;
		}
		elsif($align[$j][$i] eq "A"){
			$A++;
			$purine++;
			$weak++;
		}
		elsif($align[$j][$i] eq "T"){
			$T++;
			$pyrimidine++;
			$weak++;
		}
		elsif($align[$j][$i] eq "-"){
			$gap++;
		}
		elsif($align[$j][$i] eq "S"){
			$strong++;
		}
		elsif($align[$j][$i] eq "W"){
			$weak++;
		}
		elsif($align[$j][$i] eq "Y"){
			$pyrimidine++;
		}
		elsif($align[$j][$i] eq "R"){
			$purine++;
		}
		elsif($align[$j][$i] eq "N" || $align[$j][$i] eq "X"){
			$noID++;
		}
		else{
			$other++;
		}
	}
	my $siteN = $i+1;
	my $notgap = scalar(@align)-$gap;
	if ($notgap == 0){
		$notgap++;
	}
	my $gapProp = eval sprintf('%.4f',$gap/scalar(@align));
	my $AProp = eval sprintf('%.4f',$A/$notgap);
	my $CProp = eval sprintf('%.4f',$C/$notgap);
	my $GProp = eval sprintf('%.4f',$G/$notgap);
	my $TProp = eval sprintf('%.4f',$T/$notgap);
	my $PyrProp = eval sprintf('%.4f',$pyrimidine/$notgap);
	my $PurProp = eval sprintf('%.4f',$purine/$notgap);
	my $StrProp = eval sprintf('%.4f',$strong/$notgap);
	my $WkProp = eval sprintf('%.4f',$weak/$notgap);
	my $NXProp = eval sprintf('%.4f',$noID/$notgap);
	my $otherProp = eval sprintf('%.4f',$other/$notgap);
	print $siteN."\t".$gapProp."\t".$AProp."\t".$CProp."\t".$GProp."\t".$TProp."\t".$PyrProp."\t".$PurProp."\t".$StrProp."\t".$WkProp."\t".$NXProp."\t".$otherProp."\n";
}

exit;