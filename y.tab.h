/* A Bison parser, made by GNU Bison 2.5.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IF = 258,
     ELSE = 259,
     WHILE = 260,
     ID = 261,
     NUM = 262,
     ASSIGN = 263,
     EQ = 264,
     NEQ = 265,
     LT = 266,
     LTE = 267,
     GT = 268,
     GTE = 269,
     PLUS = 270,
     MINUS = 271,
     TIMES = 272,
     OVER = 273,
     LPAREN = 274,
     RPAREN = 275,
     LBRACK = 276,
     RBRACK = 277,
     LBRACE = 278,
     RBRACE = 279,
     SEMI = 280,
     COMMA = 281,
     ENDFILE = 282,
     ERROR = 283,
     INT = 284,
     RETURN = 285,
     VOID = 286
   };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define WHILE 260
#define ID 261
#define NUM 262
#define ASSIGN 263
#define EQ 264
#define NEQ 265
#define LT 266
#define LTE 267
#define GT 268
#define GTE 269
#define PLUS 270
#define MINUS 271
#define TIMES 272
#define OVER 273
#define LPAREN 274
#define RPAREN 275
#define LBRACK 276
#define RBRACK 277
#define LBRACE 278
#define RBRACE 279
#define SEMI 280
#define COMMA 281
#define ENDFILE 282
#define ERROR 283
#define INT 284
#define RETURN 285
#define VOID 286




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


