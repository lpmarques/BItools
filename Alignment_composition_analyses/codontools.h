#ifndef CODONTOOLS_H
#include CODONTOOLS_H

char* RNAtoAA(char *codon);
char** AAtoRNA(char *amino, int *ncodons);
char** synonyms(char *codon, int *ncodons);

#endif