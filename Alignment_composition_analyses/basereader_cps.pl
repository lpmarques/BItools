#!/usr/bin/perl

#Lê cada uma das bases ao longo de um alinhamento fasta declarado $ARGV[0], gerando como output
# informações a respeito da proporção total de bases e gaps no alinhamento.

use strict;
use warnings;

my $input = $ARGV[0];
open IN, "<$input";

my $seqcount = 0;
my (@AProp, @CProp, @GProp, @TProp, @PyrProp, @PurProp, @StrProp, @WkProp) = (0,0,0,0) x 8;
my ($gapProp, $NXProp, $otherProp, $pos, $length) = (0) x 5;
foreach my $line(<IN>){
	chomp($line);
	if ($line !~ />.+/){
		$seqcount++;
		my @seq = split("",$line);
		$length = scalar(@seq);
		foreach my $base (@seq){
			$pos++;
			if($base eq "G"){
				$GProp[0]++;
				$GProp[$pos]++;
				$PurProp[0]++;
				$PurProp[$pos]++;
				$StrProp[0]++;
				$StrProp[$pos]++;
			}
			elsif($base eq "C"){
				$CProp[0]++;
				$CProp[$pos]++;
				$PyrProp[0]++;
				$PyrProp[$pos]++;
				$StrProp[0]++;
				$StrProp[$pos]++;
			}
			elsif($base eq "A"){
				$AProp[0]++;
				$AProp[$pos]++;
				$PurProp[0]++;
				$PurProp[$pos]++;
				$WkProp[0]++;
				$WkProp[$pos]++;
			}
			elsif($base eq "T"){
				$TProp[0]++;
				$TProp[$pos]++;
				$PyrProp[0]++;
				$PyrProp[$pos]++;
				$WkProp[0]++;
				$WkProp[$pos]++;
			}
			elsif($base eq "-"){
				$gapProp++;
			}
			elsif($base eq "S"){
				$StrProp[0]++;
				$StrProp[$pos]++;
			}
			elsif($base eq "W"){
				$WkProp[0]++;
				$WkProp[$pos]++;
			}
			elsif($base eq "Y"){
				$PyrProp[0]++;
				$PyrProp[$pos]++;
			}
			elsif($base eq "R"){
				$PurProp[0]++;
				$PurProp[$pos]++;
			}
			elsif($base =~ /[NX?]/){
				$NXProp++;
			}
			else{
				$otherProp++;
			}
			if(($pos)%3 == 0){
				$pos = 0;
			}
		}
	}
}
close IN;

if($length%3 > 0){
	die "Number of sites in '$input' is not multiple of 3: sequences are either not DNA, not coding sequences (CDS) or incomplete CDS.\n";
}

print "Length\tGap_prop\tA_prop\tA1_prop\tA2_prop\tA3_prop\tC_prop\tC1_prop\tC2_prop\tC3_prop\tG_prop\tG1_prop\tG2_prop\tG3_prop\tT_prop\tT1_prop\tT2_prop\tT3_prop\tPyr_prop\tPyr1_prop\tPyr2_prop\tPyr3_prop\tPur_prop\tPur1_prop\tPur2_prop\tPur3_prop\tStr_prop\tStr1_prop\tStr2_prop\tStr3_prop\tWk_prop\tWk1_prop\tWk2_prop\tWk3_prop\tUndetChr_prop\tOther\n";

#calcula as proporções totais, as das primeiras, segundas e terceiras posições
my $bases = $seqcount*$length;
my @denom = ($bases);
@denom[1..3] = ($bases/3) x 3;
for(my $pos=0; $pos<=3; $pos++){
	$AProp[$pos] = eval(sprintf('%.4f',$AProp[$pos]/$denom[$pos]));
	$CProp[$pos] = eval(sprintf('%.4f',$CProp[$pos]/$denom[$pos]));
	$GProp[$pos] = eval(sprintf('%.4f',$GProp[$pos]/$denom[$pos]));
	$TProp[$pos] = eval(sprintf('%.4f',$TProp[$pos]/$denom[$pos]));
	$PyrProp[$pos] = eval(sprintf('%.4f',$PyrProp[$pos]/$denom[$pos]));
	$PurProp[$pos] = eval(sprintf('%.4f',$PurProp[$pos]/$denom[$pos]));
	$StrProp[$pos] = eval(sprintf('%.4f',$StrProp[$pos]/$denom[$pos]));
	$WkProp[$pos] = eval(sprintf('%.4f',$WkProp[$pos]/$denom[$pos]));
}
$gapProp = eval(sprintf('%.4f',$gapProp/$denom[0]));
$NXProp = eval(sprintf('%.4f',$NXProp/$denom[0]));
$otherProp = eval(sprintf('%.4f',$otherProp/$denom[0]));

print $length."\t".$gapProp."\t".$AProp[0]."\t".$AProp[1]."\t".$AProp[2]."\t".$AProp[3]."\t".$CProp[0]."\t".$CProp[1]."\t".$CProp[2]."\t".$CProp[3]."\t".$GProp[0]."\t".$GProp[1]."\t".$GProp[2]."\t".$GProp[3]."\t".$TProp[0]."\t".$TProp[1]."\t".$TProp[2]."\t".$TProp[3]."\t".$PyrProp[0]."\t".$PyrProp[1]."\t".$PyrProp[2]."\t".$PyrProp[3]."\t".$PurProp[0]."\t".$PurProp[1]."\t".$PurProp[2]."\t".$PurProp[3]."\t".$StrProp[0]."\t".$StrProp[1]."\t".$StrProp[2]."\t".$StrProp[3]."\t".$WkProp[0]."\t".$WkProp[1]."\t".$WkProp[2]."\t".$WkProp[3]."\t".$NXProp."\t".$otherProp."\n";

#subrotina para somatórios
sub sum{
	my $sum=0;
	foreach(@_){
		$sum = $sum+$_;
	}
	return $sum;
}

exit;