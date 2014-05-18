/****************************************************/
/* File: tiny.y                                     */
/* The TINY Yacc/Bison specification file           */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/
%{
#define YYPARSER /* distinguishes Yacc output from other code files */

#include "yacc/globals.h"
#include "util.h"

#define YYSTYPE TreeNode *
static char * savedName; /* for use in assignments */
static int savedNum; /* for use in assignments */
static int savedLineNo;  /* ditto */
static TreeNode * savedTree; /* stores syntax tree for later return */
static int yylex(void); // added 11/2/11 to ensure no conflict with lex
//char tokenString[MAXTOKENLEN+1];

%}

%token IF ELSE WHILE 
%token ID NUM 
%token ASSIGN EQ NEQ LT LTE GT GTE PLUS MINUS TIMES OVER LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI COMMA ENDFILE
%token ERROR 
%token INT RETURN VOID

%left '-'
%left '+'


%% /* Grammar for Cminus */


/* 1*/
program : declaration_list { savedTree = $1; 
};

/* 2*/
declaration_list : declaration_list declaration
					{ YYSTYPE t = $1;
						if (t != NULL)
						{ while (t->sibling != NULL)
							t = t->sibling;
							t->sibling = $2;
							$$ = $1; }
						else $$ = $2;
					}
					| declaration { $$ = $1; }
					;
					
/* 3*/
declaration : 
var_declaration { $$ = $1; } |
					 fun_declaration { $$ = $1; } 
			;
					
					
/* 4*/
var_declaration : 
				  type_specifier				 
				  ID{
					savedName = copyString(tokenString); 
					printf("DEBUG var_declaration1 %s\n",savedName);
				  }
					var_declaration_{ 
						$$ = newDecNode(VarK);
						$$->child[0] = $1;
						$$->child[1] = newExpNode(IdK); 
						printf("DEBUG var_declaration1.2 %s\n",savedName);
						$$->child[1]->attr.name = savedName;
						
						$$->child[2] = $4;
				   
					}
					;
var_declaration_ : SEMI  
				   
				    | LBRACK NUM
						{
							savedNum = atoi(tokenString);
				   		}
						RBRACK SEMI
					  {
  					 	   $$ = newExpNode(ConstK);
					       $$->attr.val = savedNum;
				      }
					;


/* 5*/
type_specifier : INT { $$ = newExpNode(TypeK);
				 	    $$->type = Integer; } 
			     | VOID { $$ = newExpNode(TypeK);
				 	    $$->type = Void; } 
				;


/* 6*/
fun_declaration : type_specifier ID{
					 savedName = copyString(tokenString);
				  } LPAREN params RPAREN compound_stmt{
					  $$ = newDecNode(FunK);
					$$->type = $1->type;
//					$$->child[0] = newExpNode(IdK);
//					$$->child[0]->attr.name = savedName;

					$$->child[0] = $5;
					$$->child[1] = $7;
				  }
				;
/* 7*/
params : param_list { $$ = $1; } 
		| VOID 		;
/* 8*/
param_list : param_list COMMA param 
		 { YYSTYPE t = $1;
		 if (t != NULL)
		 { while (t->sibling != NULL)
				t = t->sibling;
				t->sibling = $3;
				$$ = $1; 
		 }
		 else $$ = $3;
	  	 }
		 | param { $$ = $1; }
		 ;
/* 9*/
param : type_specifier ID 
		param_
		   { $$ = newParamNode(SingleK);
		     $$->type = $1->type;
		     $$->attr.name  = savedName;
			 $$->child[0] = $3;
		   }

		;
param_ :  |
		LBRACK RBRACK
			{ 
		         $$ = newParamNode(ArrK);
			}
			;

/*10*/
compound_stmt : LBRACE local_declarations statement_list RBRACE
			    { YYSTYPE t = newStmtNode(CompK);
				  t->child[0] = $2;
				  t->child[1] = $3;
				  $$ = t;
				}

				;
/*11*/
local_declarations : local_declarations var_declaration 
					{ YYSTYPE t = $1;
						if (t != NULL)
						{ while (t->sibling != NULL)
							t = t->sibling;
							t->sibling = $2;
							$$ = $1; }
						else $$ = $2;
					}
					|
					;
/*12*/
statement_list : statement_list statement  
					{ YYSTYPE t = $1;
						if (t != NULL)
						{ while (t->sibling != NULL)
							t = t->sibling;
							t->sibling = $2;
							$$ = $1; }
						else $$ = $2;
					}
			     |
				;
/*13*/
statement : expression_stmt { $$ = $1;} |
			compound_stmt { $$ = $1;} |
		   	selection_stmt { $$ = $1; }	|
		   	iteration_stmt { $$ = $1; } |
		   	return_stmt { $$ = $1; }
			;
/*14*/
expression_stmt : expression SEMI
				  {
					  $$ = $1;
				  }

				  | SEMI
					;
/*15*/
selection_stmt : IF LPAREN expression RPAREN statement
					{
						$$ = newStmtNode(IfK);
						$$->child[0] = $3;
						$$->child[1] = $5;
					}

					| IF LPAREN expression RPAREN statement ELSE statement
					{
						$$ = newStmtNode(IfK);
						$$->child[0] = $3;
						$$->child[1] = $5;
						$$->child[2] = $7;
					}
				;
/*16*/
iteration_stmt : WHILE LPAREN expression RPAREN statement
					{
						$$ = newStmtNode(IterK);
						$$->child[0] = $3;
						$$->child[1] = $5;
					}
				;
/*17*/
return_stmt : RETURN SEMI 
					{
						$$ = newStmtNode(ReturnK);

					}
			 | RETURN expression SEMI
					{
						$$ = newStmtNode(ReturnK);
						$$->child[0] = $2;

					}
;
/*18*/
expression : var ASSIGN expression 
				{
					$$ = newStmtNode(AssignK);
					$$->child[0] = $1;
					$$->child[1] = $2;
				}
			| simple_expression { $$ = $1; }
;
/*19*/
var : ID 
		{
			$$ = newExpNode(IdK);
			$$->attr.name = copyString(tokenString);	
		}
			| ID { savedName = copyString(tokenString); }
			  LBRACK expression RBRACK
		{
			$$ = newExpNode(IdK);
			$$->attr.name = savedName;
			$$->child[0] = $4;
		}
;
/*20*/
simple_expression : additive_expression LTE additive_expression
		{
			$$ = newExpNode(OpK);
			$$->child[0] = $1;
		    $$->child[1] = $3;
		    $$->attr.op = LTE;	
		} |
					additive_expression LT additive_expression
		{
			$$ = newExpNode(OpK);
			$$->child[0] = $1;
		    $$->child[1] = $3;
		    $$->attr.op = LT;	
		} |
					additive_expression GT additive_expression
		{
			$$ = newExpNode(OpK);
			$$->child[0] = $1;
		    $$->child[1] = $3;
		    $$->attr.op = GT;	
		} |
					additive_expression GTE additive_expression
		{
			$$ = newExpNode(OpK);
			$$->child[0] = $1;
		    $$->child[1] = $3;
		    $$->attr.op = GTE;	
		} |
					additive_expression EQ additive_expression
		{
			$$ = newExpNode(OpK);
			$$->child[0] = $1;
		    $$->child[1] = $3;
		    $$->attr.op = EQ;	
		} |
					additive_expression NEQ additive_expression
		{
			$$ = newExpNode(OpK);
			$$->child[0] = $1;
		    $$->child[1] = $3;
		    $$->attr.op = NEQ;	
		} |

					 additive_expression
						{
							$$ = $1;
						}
					;

/*21*/
/*relop : LTE */
		
/*22*/
additive_expression : additive_expression PLUS term 
						{
							$$ = newExpNode(OpK);
							$$->child[0] = $1;
						    $$->child[1] = $3;
						    $$->attr.op = PLUS;	
						} |
				   	  additive_expression MINUS term 
						{
							$$ = newExpNode(OpK);
							$$->child[0] = $1;
						    $$->child[1] = $3;
						    $$->attr.op = MINUS;	
						} |
					 term 
					  	{
							$$ = $1;
						}
;
/*23*/
/*addop : PLUS | MINUS*/
/*24*/
term : term TIMES factor
		{
			$$ = newExpNode(OpK);
			$$->child[0] = $1;
		    $$->child[1] = $3;
		    $$->attr.op = TIMES;	
		} |
	   term OVER factor
 		{
			$$ = newExpNode(OpK);
			$$->child[0] = $1;
		    $$->child[1] = $3;
		    $$->attr.op = OVER;	
			
		} |
	   factor
		{
			$$ = $1;
		}

;
/*25*/
/* mulop : TIMES | OVER*/
/*26*/
factor : LPAREN expression RPAREN
			 {
				$$ = $2;
			 }	 |
		 var 
		 	{
				$$ = $1;
				
			}   |
		 call 
			{
				$$ = $1;	
			}   |
		 NUM
			{
				$$ = newExpNode(ConstK);
				$$->attr.val = atoi(tokenString);
		 	}
;
/*27*/
call : ID { savedName = copyString(tokenString); }
	   LPAREN args RPAREN 
	   {
			$$ = newExpNode(CallK);
			$$->child[0] = $4;
	   }
;
/*28*/
args : arg_list { $$ = $1; } |
;
/*29*/
arg_list : arg_list COMMA expression 
				{ YYSTYPE t = $1;
					if (t != NULL)
				{ while (t->sibling != NULL)
							t = t->sibling;
					t->sibling = $2;
						$$ = $1; }
						else $$ = $2;
				}
			
		   | expression
		   		{
					$$ = $1;	
				}
;
%%

int yyerror(char * message)
{ fprintf(listing,"DEBUG Syntax error at line %d: %s\n",lineno,message);
  fprintf(listing,"Current token: ");
//  printToken(yychar,tokenString);
  Error = TRUE;
  return 0;
}

/* yylex calls getToken to make Yacc/Bison output
 * compatible with ealier versions of the TINY scanner
 */
static int yylex(void)
{ return getToken(); }

TreeNode * parse(void)
{ yyparse();
  return savedTree;
}


//program : stmt { savedTree = $1; };
///*haha*/
//stmt : VOID { $$ = newStmtNode(AssignK); };


