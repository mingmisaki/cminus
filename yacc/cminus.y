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
static int savedLineNo;  /* ditto */
static TreeNode * savedTree; /* stores syntax tree for later return */
static int yylex(void); // added 11/2/11 to ensure no conflict with lex

%}

%token IF ELSE WHILE 
%token ID NUM 
%token ASSIGN EQ NEQ LT LTE GT GTE PLUS MINUS TIMES OVER LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI COMMA ENDFILE
%token ERROR 
%token INT RETURN VOID
%%

program : stmt { printf("ok?\n"); savedTree = $1; };
stmt : INT { $$ = newStmtNode(AssignK); };


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

//program : declaration_list SEMI { printf("OK?\n"); };
///* 2*/
//declaration_list : declaration_list declaration
//					| declaration
//					;
//					
///* 3*/
//declaration : var_declaration
//					| fun_declaration
//					;
//					
///* 4*/
//var_declaration : type_specifier ID SEMI
//					| type_specifier ID LBRACK/*[*/ NUM /*]*/RBRACK SEMI
//					;
///* 5*/
//type_specifier : INT | VOID 
//				;
///* 6*/
//fun_declaration : type_specifier ID LPAREN params RPAREN compound_stmt
//				;
///* 7*/
//params : param_list | VOID 
//		;
///* 8*/
//param_list : param_list COMMA param | param
//			;
///* 9*/
//param : type_specifier ID | type_specifier ID LBRACK RBRACK
//		;
///*10*/
//compound_stmt : LBRACE local_declarations statement_list RBRACE
//				;
///*11*/
//local_declarations : local_declarations var_declaration | 
//					;
///*12*/
//statement_list : statement_list statement | 
//				;
///*13*/
//statement : expression_stmt | compound_stmt | selection_stmt
//				| iteration_stmt | return_stmt
//			;
///*14*/
//expression_stmt : expression SEMI | SEMI
//					;
///*15*/
//selection_stmt : IF LPAREN expression RPAREN statement
//					| IF LPAREN expression RPAREN statement ELSE statement
//				;
///*16*/
//iteration_stmt : WHILE LPAREN expression RPAREN statement
//				;
///*17*/
//return_stmt : RETURN SEMI | RETURN expression SEMI
//;
///*18*/
//expression : var ASSIGN expression | simple_expression
//;
///*19*/
//var : ID | ID LBRACK expression RBRACK
//;
///*20*/
//simple_expression : additive_expression relop additive_expression
//					| additive_expression
//					;
//
///*21*/
//relop : LTE | LT | GT | GTE | EQ | NEQ
//		;
///*22*/
//additive_expression : additive_expression addop term | term
//;
///*23*/
//addop : PLUS | MINUS
//;
///*24*/
//term : term mulop factor | factor
//;
///*25*/
//mulop : TIMES | OVER
//;
///*26*/
//factor : LPAREN expression RPAREN | var | call | NUM
//;
///*27*/
//call : ID LPAREN args RPAREN
//;
///*28*/
//args : arg_list | 
//;
///*29*/
//arg_list : arg_list COMMA expression | expression
//;
/* Grammar for TINY */
/*
program     : stmt_seq
                 { savedTree = $1;} 
            ;
stmt_seq    : stmt_seq SEMI stmt
                 { YYSTYPE t = $1;
                   if (t != NULL)
                   { while (t->sibling != NULL)
                        t = t->sibling;
                     t->sibling = $3;
                     $$ = $1; }
                     else $$ = $3;
                 }
            | stmt  { $$ = $1; }
            ;
stmt        : if_stmt { $$ = $1; }
            | repeat_stmt { $$ = $1; }
            | assign_stmt { $$ = $1; }
            | read_stmt { $$ = $1; }
            | write_stmt { $$ = $1; }
            | error  { $$ = NULL; }
            ;
if_stmt     : IF exp THEN stmt_seq END
                 { $$ = newStmtNode(IfK);
                   $$->child[0] = $2;
                   $$->child[1] = $4;
                 }
            | IF exp THEN stmt_seq ELSE stmt_seq END
                 { $$ = newStmtNode(IfK);
                   $$->child[0] = $2;
                   $$->child[1] = $4;
                   $$->child[2] = $6;
                 }
            ;
repeat_stmt : REPEAT stmt_seq UNTIL exp
                 { $$ = newStmtNode(RepeatK);
                   $$->child[0] = $2;
                   $$->child[1] = $4;
                 }
            ;
assign_stmt : ID { savedName = copyString(tokenString);
                   savedLineNo = lineno; }
              ASSIGN exp
                 { $$ = newStmtNode(AssignK);
                   $$->child[0] = $4;
                   $$->attr.name = savedName;
                   $$->lineno = savedLineNo;
                 }
            ;
read_stmt   : READ ID
                 { $$ = newStmtNode(ReadK);
                   $$->attr.name =
                     copyString(tokenString);
                 }
            ;
write_stmt  : WRITE exp
                 { $$ = newStmtNode(WriteK);
                   $$->child[0] = $2;
                 }
            ;
exp         : simple_exp LT simple_exp 
                 { $$ = newExpNode(OpK);
                   $$->child[0] = $1;
                   $$->child[1] = $3;
                   $$->attr.op = LT;
                 }
            | simple_exp EQ simple_exp
                 { $$ = newExpNode(OpK);
                   $$->child[0] = $1;
                   $$->child[1] = $3;
                   $$->attr.op = EQ;
                 }
            | simple_exp { $$ = $1; }
            ;
simple_exp  : simple_exp PLUS term 
                 { $$ = newExpNode(OpK);
                   $$->child[0] = $1;
                   $$->child[1] = $3;
                   $$->attr.op = PLUS;
                 }
            | simple_exp MINUS term
                 { $$ = newExpNode(OpK);
                   $$->child[0] = $1;
                   $$->child[1] = $3;
                   $$->attr.op = MINUS;
                 } 
            | term { $$ = $1; }
            ;
term        : term TIMES factor 
                 { $$ = newExpNode(OpK);
                   $$->child[0] = $1;
                   $$->child[1] = $3;
                   $$->attr.op = TIMES;
                 }
            | term OVER factor
                 { $$ = newExpNode(OpK);
                   $$->child[0] = $1;
                   $$->child[1] = $3;
                   $$->attr.op = OVER;
                 }
            | factor { $$ = $1; }
            ;
factor      : LPAREN exp RPAREN
                 { $$ = $2; }
            | NUM
                 { $$ = newExpNode(ConstK);
                   $$->attr.val = atoi(tokenString);
                 }
            | ID { $$ = newExpNode(IdK);
                   $$->attr.name =
                         copyString(tokenString);
                 }
            | error { $$ = NULL; }
            ;
*/
