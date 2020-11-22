#include <stdio.h>
#include <string.h>
#include <stdlib.h>
  
void compute_prefix_function(char* pat, int M, int* pi); 
  
void KMP_Matcher(char* txt, char* pat) 
{ 
    int M = strlen(pat); 
    int N = strlen(txt);  
    int pi[M]; 
   
    compute_prefix_function(pat, M, pi); 
  
    int i = 0; 
    int j = 0;  
    while (i < N) { 
        if (pat[j] == txt[i]) { 
            j++; 
            i++; 
        } 
  
        if (j == M) { 
            printf("Indeks %d \n", i - j); 
            j = pi[j - 1]; 
        } 
        else if (i < N && pat[j] != txt[i]) { 
            if (j != 0) 
                j = pi[j - 1]; 
            else
                i = i + 1; 
        } 
    } 
} 

void compute_prefix_function(char* pat, int M, int* pi) { 
    int length = 0; 
    pi[0] = 0;
    int i = 1; 

    while (i < M) { 
        if (pat[i] == pat[length]) { 
            length++; 
            pi[i] = length; 
            i++; 
        } 
        else{  
            if (length != 0) { 
                length = pi[length - 1];  
            } 
            else{ 
                pi[i] = 0; 
                i++; 
            } 
        } 
    } 
} 

int main(int argc, char *argv[]) 
{

    FILE *f = fopen(argv[2], "rb");
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);  

    char *txt = malloc(size + 1);
    fread(txt, 1, size, f);
    fclose(f);

    txt[size] = 0;



    char* pat;
    pat = (char*)malloc(sizeof(char) * strlen(argv[1]));
    strcpy(pat, argv[1]); 

    KMP_Matcher(txt, pat); 
    return 0; 
}