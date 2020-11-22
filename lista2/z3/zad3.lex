%{
	int remdox   = 0;
	int singlDox = 0;
	int multiDox = 0;
	int singlCom = 0;
	int multiCom = 0;
%}

single_com		\/\/
multi_com 		\/\* 
end_of_com		\*\/
single_dox		\/\/(\/|!)
multi_dox		\/\*(\*|!)

%x is_str
%x include
%x singleline_comment
%x multiline_comment
%x singleline_dox_comment
%x multiline_dox_comment


%%

\"                      {fprintf(yyout, "%s", yytext); BEGIN(is_str);}
<is_str>{
\\\"					{fprintf(yyout, "%s", yytext);}
\"                  	{fprintf(yyout, "%s", yytext); BEGIN(INITIAL);}
.                       {fprintf(yyout, "%s", yytext);}
}


#include[[:blank:]]*\<  {fprintf(yyout, "%s", yytext); BEGIN(include);}
<include>{
>                       {fprintf(yyout, "%s", yytext); BEGIN(INITIAL);}
.|\n                    {fprintf(yyout, "%s", yytext);}
}


{single_com}			{ 
		if(singlDox || multiDox || singlCom || multiCom)
			{fprintf(yyout, "%s", yytext);}
		else
			{singlCom = 1; BEGIN(singleline_comment);}
	}
<singleline_comment>{
.*\\\n       			;
.               		;
[^\\]\n         		{fprintf(yyout, "\n"); singlCom = 0; BEGIN(INITIAL);}		
}


{multi_com}			    {
		if(singlDox || multiDox || singlCom || multiCom)
			{fprintf(yyout, "%s", yytext);}
		else
			{multiCom = 1; BEGIN(multiline_comment);}
}
<multiline_comment>{
.|\n                	;
{end_of_com}			{multiCom = 0; fprintf(yyout, "\n"); BEGIN(INITIAL);}	
}


{single_dox}			{ 
		if(singlDox || multiDox || singlCom || multiCom)
			{fprintf(yyout, "%s", yytext);}
		else if(remdox)
			{singlDox = 1; BEGIN(singleline_dox_comment);}
		else
			{fprintf(yyout, "%s", yytext); singlDox = 1; BEGIN(singleline_dox_comment);}
	}
<singleline_dox_comment>{
.*\\\n                 	{if (!remdox) fprintf(yyout, "%s", yytext);}
.                       {if (!remdox) fprintf(yyout, "%s", yytext);}
[^\\]\n                 { 
		if(remdox) 
			{fprintf(yyout, "\n"); singlDox = 0; BEGIN(INITIAL);}
		else 
			{fprintf(yyout, "%s", yytext); singlDox = 0; BEGIN(INITIAL);}
	}		
}


{multi_dox}			  	{ 
		if(singlDox || multiDox || singlCom || multiCom)
			{fprintf(yyout, "%s", yytext);}
		else if(remdox)
			{multiDox = 1; BEGIN(multiline_dox_comment);}
		else
			{fprintf(yyout, "%s", yytext); multiDox = 1; BEGIN(multiline_dox_comment);}
	}
<multiline_dox_comment>{
.|\n                 	{if (!remdox) fprintf(yyout, "%s", yytext);}
{end_of_com}                     { 
		if(remdox) 
			{fprintf(yyout, "\n"); multiDox = 0; BEGIN(INITIAL);}
		else 
			{fprintf(yyout, "%s", yytext); multiDox = 0; BEGIN(INITIAL);}
	}		
}


^(?:[\t ]*(?:\r?\n|\r))+	{fprintf(yyout, "");}

%%

int yywrap(){};

int main(int argc, char **argv)
{
	extern FILE *yyin, *yyout;

	if (argc==1)
	{
		printf("Argument 0: ./zad3\nArgument 1: Nazwa pliku wejsciowego\nArgument 2: wpisac dowolna linijke żeby usunąć doxygen komentarze\n");
		return 0;
	}
	else
	{
		yyin = fopen(argv[1], "r");
		if (argc==3)
		{
			remdox = 1;
		}
		else if(argc>3){
			printf("Za dużo argumentów!\n");
			return 0;
		}
	}
	
	yyout = fopen("output.cpp", "w");
	yylex();
	return 0;
}




