#include <stdio.h> 
#include <string.h> 
#include <stdlib.h>
  
int nextState(char *pat, int M, int state, int x) 
{ 

    if (state < M && x == pat[state]) 
        return state+1; 
    int ns, i; 
  
    for (ns = state; ns > 0; ns--) 
    { 
        if (pat[ns-1] == x) 
        { 
            for (i = 0; i < ns-1; i++) 
                if (pat[i] != pat[state-ns+1+i]) 
                    break; 
            if (i == ns-1) 
                return ns; 
        } 
    } 
  
    return 0; 
} 

void computeTF(char *pat, int M, int TF[][256]) 
{ 
    int state, x; 
    for (state = 0; state <= M; ++state) 
        for (x = 0; x < 256; ++x) 
            TF[state][x] = nextState(pat, M, state, x); 
} 
  

void search(char *pat, char *txt) 
{ 
    int M = strlen(pat); 
    int N = strlen(txt); 
  
    int TF[M+1][256]; 
  
    computeTF(pat, M, TF); 
  

    int i, state=0; 
    for (i = 0; i < N; i++) 
    { 
        state = TF[state][txt[i]]; 
        if (state == M) 
            printf ("Indeks %d\n", i-M+1); 
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

    search(pat, txt); 
    return 0; 
} 