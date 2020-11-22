%{
	#define STACK_SIZE 128
	#include<stdio.h>
	#include<math.h>


	int error = 0;
	int pointer = -1;
	int stack[STACK_SIZE];

	int pop(){
		if (pointer >= 0){
		    pointer--;
		    return stack[pointer + 1];
		} 
		else{
		    error = 1;
		    return 0;
		}
	}


	void push(int num){
		pointer++;
		if (pointer < STACK_SIZE)
		    stack[pointer] = num;
		else{
		    printf("Stack Overflow");
		    error = 1;
		}
	}
	
	void power(){
		push(pow(pop(), pop()));
	}
	
	void result(){
		if(!error){
			if (pointer == 0){
				printf("=  %d\n", pop());
			} 
			else if(pointer > 0 ){
				printf("Za mała liczba operatorów!\n");
			}
		} 
		else{
			printf("Za mała liczba argumentów!\n");
			error = 0;
		}
		pointer = -1;
	}
%}


%x ERROR


%%
-?[0-9]+	push(atoi(yytext));
"+"			{push(pop() + pop()); if(error) BEGIN(ERROR);}
"-"			{int subtrahend = pop(); push(pop() - subtrahend); if (error) BEGIN(ERROR);}
"*"			{push(pop() * pop());}
"/"        	{int divisor = pop();
			 	if (divisor == 0){
				 	printf("Nie można dzielić przez 0!\n");BEGIN(ERROR);
				} 
				else{
					push(pop()/divisor);
				}
				if (error) BEGIN(ERROR);
			}
"%"         {
		        int divisor = pop();
		        if (divisor == 0) {
		            printf("Nie można dzielić przez 0!\n");BEGIN(ERROR);
		        }
		        else{
		            push(pop() % divisor);
		        }
		        if (error){
		        	BEGIN(ERROR);
		        }
			}
"^"             power();
\n            	result();
[^[:blank:]]    {printf("This symbol is not allowed: %s\n", yytext); error = 1;};
[[:blank:]]     ;

<ERROR>.*       ;
<ERROR>\n       { pointer = -1; error = 0; BEGIN(INITIAL); }
%%

int yywrap(){}

int main()
{
    yylex();
    return 0;
}

