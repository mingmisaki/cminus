/****************************************************/
/* File: c.l                                     */
/* Lex specification for c- language*/
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden and Leonardo Heo Jun           */
/****************************************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

letter      [a-zA-Z]
digit       [0-9]
identifier  {letter}+
number      {digit}+
newline     \n
whitespace  [ \t]+

%%

"/*"			{skipcmnts();}
"if"            {return IF;}
"else"          {return ELSE;}
"while"        {return WHILE;}
"="            {return ASSIGN;}
"=="             {return EQ;}
"!="             {return NEQ;}
"<"             {return LT;}
"<="             {return LTE;}
">"             {return GT;}
">="             {return GTE;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
"["             {return LBRACK;}
"]"             {return RBRACK;}
"{"             {return LBRACE;}
"}"             {return RBRACE;}
";"             {return SEMI;}
","             {return COMMA;}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}

.               {return ERROR;}

%%
int yywrap(void)
{
	return 1;
}
TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = source;
    yyout = listing;
  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  if (1) {
    fprintf(listing,"\t%2d              ",lineno);
    printToken(currentToken,tokenString);
  }
  return currentToken;
}

int skipcmnts()
{
	int c;
	int n=0;
	char t='0';

	while ( ( c = input()) != (-1))
	{
		t = (char)c;
		if(t == '\n') lineno++;
		if ( t == '*')
		{
			while ((c = input()) == 42)
				//fprintf(listing,"DEBUG1 %c(%d)\n",t,c);

			t = (char)c;
			if(t == '\n') lineno++;

			if ( c == 47){

				//fprintf(listing,"DEBUG2 %c(%d)\n",t,c);
				return 0;
			}

			if ( c == (-1)){
				break;
			}
		}
	
	//fprintf(listing,"%c(%d) ",t,c);
	}
	fprintf(listing,"commnet ERROR!\n");
}


