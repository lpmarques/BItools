#!/usr/bin/perl

#Lê cada uma das bases ao longo de um alinhamento fasta declarado em $ARGV[0], gerando como output
# informações a respeito da proporção total de bases e gaps no alinhamento.

use strict;
use warnings;

my $input = $ARGV[0];
open IN, "<$input";

my $seqcount = 0;
my @seq;
my ($G, $C, $A, $T, $gap, $strong, $weak, $purine, $pyrimidine, $noID, $other) = (0) x 11;
foreach my $line(<IN>){
	chomp($line);
	if ($line !~ />.+/){
		$seqcount++;
		@seq = split("",$line);
		foreach my $base (@seq){
			if($base eq "G"){
				$G++;
				$purine++;
				$strong++;
			}
			elsif($base eq "C"){
				$C++;
				$pyrimidine++;
				$strong++;
			}
			elsif($base eq "A"){
				$A++;
				$purine++;
				$weak++;
			}
			elsif($base eq "T"){
				$T++;
				$pyrimidine++;
				$weak++;
			}
			elsif($base eq "-"){
				$gap++;
			}
			elsif($base eq "S"){
				$strong++;
			}
			elsif($base eq "W"){
				$weak++;
			}
			elsif($base eq "Y"){
				$pyrimidine++;
			}

			elsif($base eq "R"){
				$purine++;
			}
			elsif($base =~ /[NX?]/){
				$noID++;
			}
			else{
				$other++;
			}
		}
	}
}
close IN;

print "Length\tGap_prop\tA_prop\tC_prop\tG_prop\tT_prop\tPyr_prop\tPur_prop\tStr_prop\tWk_prop\tUndetChr_prop\tOther\n";
my $length = scalar(@seq);
my $bases = $length*$seqcount;
my $gapProp = eval sprintf('%.4f',$gap/$bases);
my $AProp = eval sprintf('%.4f',$A/$bases);
my $CProp = eval sprintf('%.4f',$C/$bases);
my $GProp = eval sprintf('%.4f',$G/$bases);
my $TProp = eval sprintf('%.4f',$T/$bases);
my $PyrProp = eval sprintf('%.4f',$pyrimidine/$bases);
my $PurProp = eval sprintf('%.4f',$purine/$bases);
my $StrProp = eval sprintf('%.4f',$strong/$bases);
my $WkProp = eval sprintf('%.4f',$weak/$bases);
my $NXProp = eval sprintf('%.4f',$noID/$bases);
my $otherProp = eval sprintf('%.4f',$other/$bases);
print $length."\t".$gapProp."\t".$AProp."\t".$CProp."\t".$GProp."\t".$TProp."\t".$PyrProp."\t".$PurProp."\t".$StrProp."\t".$WkProp."\t".$noID."\t".$otherProp."\n";

exit;