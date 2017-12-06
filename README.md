#BItools Library

##Description

A handful of tools developed to facilitate any generic workflow in bioinformatics.
Specially useful for research in phylogenomics (often stalled by overwhelming amounts of DNA and gigantic trees).

##Scripts for sequence processing

###multiGB2fasta.pl
	From a **multigb** file (obtained with any quick search of interest in [GenBank](https://www.ncbi.nlm.nih.gov/genbank/)), this script captures only the coding section (CDS) for each sequence and outputs them into a simpified **fasta** (multisequence file format) for each gene found. These fasta files keep info like species name and accession number for each sequence in the database.
	Aditionally, the script automatically filters CDSs by their size, so that each fasta includes only the longest CDS for each species it represents, maximizing data utilization for phylogenetics.

	call: `perl multiGB2fasta.pl <multigbfile.gb>`

###seqSelector.pl
	Provided a multisequence file in **fasta** format and a **txt** file containing a list of patterns (such as species names and/or accession numbers), this script produces a new **fasta** file containing only those sequences that match at least one of the patterns passed.

	call: `perl seqSelector.pl <sequencefile.fasta> <patternlist.txt>`

###fasta2phylip-vv.pl
	Here '-vv' stands for vice-versa. This script simply converts any sequence alignment in **fasta** or **sequential phylip** format to the other one. Specific format extensions (like *.fasta* or *.phy) must not be a concern, since fasta2phylip-vv identifies the file format by its content (the same is true to all other scripts in BItools);

	call: `perl fasta2phylip-vv.pl <alignmentfile.[fasta|phy]>`

###noGapOnlySites.pl
	Provided a sequence alignment file in **sequential phylip** format, outputs a new version of the file free of gap-only sites (which are void of useful information for phylogenetic analyses).

	call: `perl noGapOnlySites.pl <alignmentfile.phy>`

###trimmer.pl
	Trims the gappy edges of the given sequence alignment (**fasta** format). Provided a numeric threshold (**%**), it eliminates all sites on both flanking regions of the alignment up to any with gap-percentage below this threshold. The output is a **sequential fasta** file with all remaining sites.

	call: `perl trimmer.pl <alignmentfile.fasta> <flanking-gap-threshold(%)>`

###zblocks.pl
	Like trimmer.pl but also eliminates all middle sites which **absolute** number of gaps surpasses another given numeric threshold.

	call: `perl zblocks.pl <alignmentfile.fasta> <flanking-gap-threshold(%)> <middle-gap-threshold(#)>`


##Scripts for alignment composition analyses

###gapcounter.pl
	Returns the total gap proportion of the given sequence alignment (**fasta** or **sequential phylip** format).

	call: `perl gapcounter.pl <alignmentfile.[fasta|phy]>`

###basereader.pl
	Provided a DNA sequence alignment (**fasta** or **sequential phylip** format), returns a tab separated table including its length (i.e. number of sites) and total proportions of gap and each nucleotide base type in the alignment (A, T, G, C and also pyrimidines [C|T|Y], purines [G|A|R], strong bases [C|G], weak bases [A|T] and undetermined bases [N|X|?]).

	call: `perl basereader.pl <alignmentfile.[fasta|phy]`

###basereader-cps.pl
	Same as basereader.pl but also discriminates partial base proportions for each type of codon position (first, second and third) across the alignment. This feature demands the input sequence aligment to contain CDS only.

	call: `perl basereader.pl <alignmentfile.[fasta|phy]`

###sitereader.pl
	Like basereader.pl but returns in-site proportions for all sites across the sequence alignment. Each row on the table now represents a specific site, from the first one to the last.

	call: `perl basereader.pl <alignmentfile.[fasta|phy]`

##Scripts for automated tree analyses

###treelength.pl
	Given an input file containing a **newick** format (i.e. parenthetic) tree, returns its total length (sum of all branch lengths).

	call: `perl treelength.pl <treefile.nwk>`

###treePath.R
	R function that takes as input a **phylo** format tree and the IDs to any two nodes of the tree (internal and/or edge nodes - ID can be a taxon name in the latter case), returning the shortest path distance between them. This distance will correspond to the total number of branches in the path (by default) or to the sum of their lengths (if `length.sensitive=TRUE` is specified as well).

###unroot.pl
	Perl subroutine to unroot any **newick** tree given as argument.

###treeDist.pl
	Perl subroutine that returns the partition difference between two unrooted **newick** trees given as arguments. The partition difference here is the absolute number of partitions *not shared* by these trees (by default) or the same number weighted by the branch lengths that represent each partition (if option `1` is specified as a third argument). In the latter case, differences in branch lengths of partitions that *are* shared are also considered.