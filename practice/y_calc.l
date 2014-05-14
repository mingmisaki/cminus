%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylval;
%}
%%
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
[\t ]+ ;
\n return 0;
. return yytext[0];
"int" {return INT;}
"void" {return VOID;}

%%
