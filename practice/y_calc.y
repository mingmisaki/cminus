%{
#include <stdio.h>
%}

%token NAME NUMBER
%token INT VOID
%%
statement: NAME '=' expression
			| expression { printf("= %d\n", $1); }
			| INT { printf("int\n"); }
			;
expression: expression '+' NUMBER { $$ = $1 + $3; }
			| expression '-' NUMBER { $$ = $1 - $3; }
			| NUMBER { $$ = $1; }
			;
%%
void yyerror(const char *s)
{
	fprintf(stderr, "%s\n",s);
	return;
}
int main(void)
{
	yyparse();
	return 0;
}
