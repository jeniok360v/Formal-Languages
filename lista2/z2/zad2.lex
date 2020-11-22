%%
\n#(.*)						{fprintf(yyout, "");}
#(.*)$						{fprintf(yyout, "");}
\"\"\"(.*\n*.*)(\"\"\")+?	{fprintf(yyout, "");}
[[:alnum:]]+				{fprintf(yyout, "%s", yytext);}
%%

int yywrap(){};

int main(){
	extern FILE *yyin, *yyout;
	yyin = fopen("testinput.py", "r");
	yyout = fopen("testoutput.py", "w");
	yylex();
	return 0;
}