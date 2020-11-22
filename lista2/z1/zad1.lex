%{
	int lines = 0;
	int words = 0;
%}

%%
^[ \t]+						{fprintf(yyout, "");}
[ \t]+$						{fprintf(yyout, "");}
[ \t]+						{fprintf(yyout, " ");}
^(?:[\t ]*(?:\r?\n|\r))+	{fprintf(yyout, "");}
[[:alnum:]]+				{fprintf(yyout, "%s", yytext); words++;} 
[\n]						{fprintf(yyout, "\n"); lines++;} 
%%

int yywrap(){};

int main(){
	extern FILE *yyin, *yyout;
	yyin = fopen("testinput.txt", "r");
	yyout = fopen("testoutput.txt", "w");
	yylex();
	printf("Lines: %i. Words: %i\n", lines+1, words);
	return 0;
}