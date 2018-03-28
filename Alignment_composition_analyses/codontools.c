#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utilslib.h"

char* RNAtoAA(char *codon){

	if(codon[0]=='U'){
		
		if(codon[1]=='U'){
			
			if(codon[2]=='U' || codon[2]=='C'){
				
				return "Phenyl-alanine";
			}
			else if(codon[2]=='A' || codon[2]=='G'){
				
				return "Leucine";
			}
		}
		else if(codon[1]=='C'){
			
			return "Serine";
		}
		else if(codon[1]=='A'){
			
				if(codon[2]=='U' || codon[2]=='C'){
					
					return "Tyrosine";
				}
				else if(codon[2]=='A' || codon[2]=='G'){
					
					return "stop";
				}
		}
		else if(codon[1]=='G'){
			
				if(codon[2]=='U' || codon[2]=='C'){
					
					return "Cysteine";
				}
				else if(codon[2]=='A'){
					
					return "stop";
				}
				else if(codon[2]=='G'){
					
					return "Tryptophan";
				}
		}
	}
	else if(codon[0]=='C'){
		
			if(codon[1]=='U'){
				
				return "Leucine";
			}
			else if(codon[1]=='C'){
				
				return "Proline";
			}
			else if(codon[1]=='A'){
				
					if(codon[2]=='U' || codon[2]=='C'){
						
						return "Histidine";
					}
					else if(codon[2]=='A' || codon[2]=='G'){
						
						return "Glutamate";
					}
			}
			else if(codon[1]=='G'){
				
				return "Arginine";
			}
	}
	else if(codon[0]=='A'){
		
			if(codon[1]=='U'){
				
				if(codon[2]=='U' || codon[2]=='C' || codon[2]=='A'){
					
					return "Isoleucine";
				}
				else if(codon[2]=='G'){
					
					return "Methionine";
				}
			}
			else if(codon[1]=='C'){
				
				return "Threonine";
			}
			else if(codon[1]=='A'){
				
					if(codon[2]=='U' || codon[2]=='C'){
						
						return "Asparagine";
					}
					else if(codon[2]=='A' || codon[2]=='G'){
						
						return "Lysine";
					}
			}
			else if(codon[1]=='G'){
				
					if(codon[2]=='U' || codon[2]=='C'){
						
						return "Serine";
					}
					else if(codon[2]=='A' || codon[2]=='G'){
						
						return "Arginine";
					}
			}
	}
	else if(codon[0]=='G'){
		
			if(codon[1]=='U'){
				
				return "Valine";
			}
			else if(codon[1]=='C'){
				
				return "Alanine";
			}
			else if(codon[1]=='A'){
				
					if(codon[2]=='U' || codon[2]=='C'){
						
						return "Aspartic_acid";	
					}
					else if(codon[2]=='A' || codon[2]=='G'){
						
						return "Glutamic_acid";
					}

			}
			else if(codon[1]=='G'){
				
				return "Glycine";
			}
	}

	printf("RNAtoAA: Could not id codon %s\n",codon);
	exit(1);
}

char** AAtoRNA(char *amino, int *ncodons){
	char **codons;

	if(streq(amino,"Phenyl-alanine")){

		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "UUU";
		codons[1] = "UUC";
		*ncodons = 2;
	}
	else if(streq(amino,"Leucine")){

		codons = (char **)allocPointerToPointer(6,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "UUA";
		codons[1] = "UUG";
		codons[2] = "CUU";
		codons[3] = "CUC";
		codons[4] = "CUA";
		codons[5] = "CUG";
		*ncodons = 6;
	}
	else if(streq(amino,"Serine")){

		codons = (char **)allocPointerToPointer(6,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "UCU";
		codons[1] = "UCC";
		codons[2] = "UCA";
		codons[3] = "UCG";
		codons[4] = "AGU";
		codons[5] = "AGC";
		*ncodons = 6;
	}
	else if(streq(amino,"Tyrosine")){

		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "UAU";
		codons[1] = "UAC";
		*ncodons = 2;
	}
	else if(streq(amino,"stop")){

		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "UAA";
		codons[1] = "UAG";
		codons[2] = "UGA";
		*ncodons = 3;
	}
	else if(streq(amino,"Cysteine")){

		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "UGU";
		codons[1] = "UGC";
		*ncodons = 2;
	}
	else if(streq(amino,"Tryptophan")){

		codons = (char **)allocPointerToPointer(1,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "UGG";
		*ncodons = 1;
	}
	else if(streq(amino,"Proline")){

		codons = (char **)allocPointerToPointer(4,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "CCU";
		codons[1] = "CCC";
		codons[2] = "CCA";
		codons[3] = "CCG";
		*ncodons = 4;
	}
	else if(streq(amino,"Histidine")){
		
		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "CAU";
		codons[1] = "CAC";
		*ncodons = 2;
	}
	else if(streq(amino,"Glutamate")){
		
		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "CAA";
		codons[1] = "CAG";
		*ncodons = 2;
	}
	else if(streq(amino,"Arginine")){
		
		codons = (char **)allocPointerToPointer(4,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "CGU";
		codons[1] = "CGC";
		codons[2] = "CGA";
		codons[3] = "CGG";
		*ncodons = 4;
	}
	else if(streq(amino,"Isoleucine")){
		
		codons = (char **)allocPointerToPointer(3,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "AUU";
		codons[1] = "AUC";
		codons[2] = "AUA";
		*ncodons = 3;
	}
	else if(streq(amino,"Methionine")){
		
		codons = (char **)allocPointerToPointer(1,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "AUG";
		*ncodons = 1;
	}
	else if(streq(amino,"Threonine")){
		
		codons = (char **)allocPointerToPointer(4,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "ACU";
		codons[1] = "ACC";
		codons[2] = "ACA";
		codons[3] = "ACG";
		*ncodons = 4;
	}
	else if(streq(amino,"Asparagine")){
		
		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "AAU";
		codons[1] = "AAC";
		*ncodons = 2;
	}
	else if(streq(amino,"Lysine")){
		
		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "AAA";
		codons[1] = "AAG";
		*ncodons = 2;
	}
	else if(streq(amino,"Arginine")){
		
		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "AGA";
		codons[1] = "AGG";
		*ncodons = 2;
	}
	else if(streq(amino,"Valine")){
		
		codons = (char **)allocPointerToPointer(4,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "GUU";
		codons[1] = "GUC";
		codons[2] = "GUA";
		codons[3] = "GUG";
		*ncodons = 4;
	}
	else if(streq(amino,"Alanine")){
		
		codons = (char **)allocPointerToPointer(4,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "GCU";
		codons[1] = "GCC";
		codons[2] = "GCA";
		codons[3] = "GCG";
		*ncodons = 4;
	}
	else if(streq(amino,"Aspartic_acid")){
		
		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "GAU";
		codons[1] = "GAC";
		*ncodons = 2;
	}
	else if(streq(amino,"Glutamic_acid")){
		
		codons = (char **)allocPointerToPointer(2,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "GAA";
		codons[1] = "GAG";
		*ncodons = 2;
	}
	else if(streq(amino,"Glycine")){
		
		codons = (char **)allocPointerToPointer(4,3,sizeof(char));
		checkMemAlloc(codons);
		codons[0] = "GGU";
		codons[1] = "GGC";
		codons[2] = "GGA";
		codons[3] = "GGG";
		*ncodons = 4;
		*ncodons = 4;
	}
	else{
		printf("AAtoRNA: Could not id amino-acid %s\n",amino);
		exit(1);
	}

	return codons;
}

char** synonyms(char *codon, int *ncodons){

	char **fam = AAtoRNA(RNAtoAA(codon),ncodons);
	
	char **syns;
	syns = (char **)allocPointerToPointer(*ncodons-1,3,sizeof(*syns));

	int i,j;
	for(j=i=0; i<*ncodons; i++)
		if(!streq(codon,fam[i])){	
			syns[j] = fam[i];
			j++;
		}

	free(fam);

	*ncodons = j;
	return syns;
}