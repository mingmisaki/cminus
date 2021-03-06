/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "./yacc/globals.h"
#include "util.h"
#include "y.tab.h"

/* Procedure printToken prints a token 
 * and its lexeme to the listing file
 */
void printToken( TokenType token, const char* tokenString )
{ switch (token)
  { case IF: fprintf(listing, "IF           if\n"); break;
    case ELSE:fprintf(listing, "ELSE         else\n"); break;
    case WHILE:fprintf(listing, "WHILE        while\n"); break;
    case ASSIGN: fprintf(listing,"ASSIGN       =\n"); break;
    case EQ: fprintf(listing,"EQ           ==\n"); break;
    case NEQ: fprintf(listing,"NEQ          !=\n"); break;
    case LT: fprintf(listing,"LT           <\n"); break;
    case LTE: fprintf(listing,"LTE          <=\n"); break;
    case GT: fprintf(listing,"GT           >\n"); break;
    case GTE: fprintf(listing,"GTE          >=\n"); break;
    case PLUS: fprintf(listing,"PLUS         +\n"); break;
    case MINUS: fprintf(listing,"MINUX        -\n"); break;
    case TIMES: fprintf(listing,"TIMES        *\n"); break;
    case OVER: fprintf(listing,"OVER         /\n"); break;
    case LPAREN: fprintf(listing,"LPAREN       (\n"); break;
    case RPAREN: fprintf(listing,"RPAREN       )\n"); break;
    case LBRACK: fprintf(listing,"LBRACK       [\n"); break;
    case RBRACK: fprintf(listing,"RBLACK       ]\n"); break;
    case LBRACE: fprintf(listing,"LBRACE       {\n"); break;
    case RBRACE: fprintf(listing,"RBRACE       }\n"); break;
    case SEMI: fprintf(listing,"SEMI         ;\n"); break;
    case COMMA: fprintf(listing,"COMMA        ,\n"); break;
    case ENDFILE: fprintf(listing,"ENDFILE      EOF\n"); break;
    case NUM:
      fprintf(listing,
          "NUM          %s\n",tokenString);
      break;
    case ID:
      fprintf(listing,
          "ID           %s\n",tokenString);
      break;
    case ERROR:
      fprintf(listing,
          "ERROR          \n",tokenString);
      break;
    default: /* should never happen */
      fprintf(listing,"Unknown token: %d\n",token);
  }
}

/* Function newDecNode creates a new declaration
 * node for syntax tree construction
 */
TreeNode * newDecNode(DecKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
  int i;
  if (t==NULL)
    fprintf(listing,"Out of memory error at line %d\n",lineno);
  else {

    t->sibling = NULL;
    t->nodekind = DecK;
    t->kind.dec = kind;
    t->lineno = lineno;
  }
  return t;
}
/* Function newStmtNode creates a new statement
 * node for syntax tree construction
 */
TreeNode * newStmtNode(StmtKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
  int i;
  if (t==NULL)
    fprintf(listing,"Out of memory error at line %d\n",lineno);
  else {

    t->sibling = NULL;
    t->nodekind = StmtK;
    t->kind.stmt = kind;
    t->lineno = lineno;
  }
  return t;
}

/* Function newExpNode creates a new expression 
 * node for syntax tree construction
 */
TreeNode * newExpNode(ExpKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
  int i;
  if (t==NULL)
    fprintf(listing,"Out of memory error at line %d\n",lineno);
  else {
    for (i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
    t->sibling = NULL;
    t->nodekind = ExpK;
    t->kind.exp = kind;
    t->lineno = lineno;
  }
  return t;
}
/* Function newPramNode creates a new paramter 
 * node for syntax tree construction
 */
TreeNode * newParamNode(ParamKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
  int i;
  if (t==NULL)
    fprintf(listing,"Out of memory error at line %d\n",lineno);
  else {
    for (i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
    t->sibling = NULL;
    t->nodekind = ParamK;
    t->kind.param= kind; //variable or array type(kind)
    t->lineno = lineno;
  }
  return t;
}

/* Function copyString allocates and makes a new
 * copy of an existing string
 */
char * copyString(char * s)
{ int n;
  char * t;
  if (s==NULL) return NULL;
  n = strlen(s)+1;
  t = malloc(n);
  if (t==NULL)
    fprintf(listing,"Out of memory error at line %d\n",lineno);
  else strcpy(t,s);
  return t;
}

/* Variable indentno is used by printTree to
 * store current number of spaces to indent
 */
static indentno = 0;

/* macros to increase/decrease indentation */
#define INDENT indentno+=2
#define UNINDENT indentno-=2

/* printSpaces indents by printing spaces */
static void printSpaces(void)
{ int i;
  for (i=0;i<indentno;i++)
    fprintf(listing," ");
}

/* procedure printTree prints a syntax tree to the 
 * listing file using indentation to indicate subtrees
 */
void printTree( TreeNode * tree )
{ int i;
  INDENT;
  while (tree != NULL) {
    printSpaces();
    if (tree->nodekind==StmtK)
    { switch (tree->kind.stmt) {
        case IfK:
          fprintf(listing,"If\n");
          break;
        case IterK:
          fprintf(listing,"While\n");
          break;
        case AssignK:
          fprintf(listing,"Assign to\n");
          break;
        case CompK:
          fprintf(listing,"Compound statement: \n");
          break;
        case ReturnK:
          fprintf(listing,"Return: \n");
          break;
        default:
          fprintf(listing,"Unknown ExpNode kind\n");
          break;
      }
    }
    else if (tree->nodekind==ExpK)
    { switch (tree->kind.exp) {
        case OpK:
          fprintf(listing,"Op: ");
          printToken(tree->attr.op,"\0");
          break;
        case ConstK:
          fprintf(listing,"Const: %d\n",tree->attr.val);
          break;
        case IdK:
          fprintf(listing,"Id: %s\n",tree->attr.name);
          break;
        case TypeK:
		  if(tree->type == Integer)
	          fprintf(listing,"Integer Type\n");
		  else
			  fprintf(listing,"Void Type\n");
          break;
        case CallK:
          fprintf(listing,"Function Call Expression: %s\n",tree->child[0]->attr.name);
//          fprintf(listing,"Function Call Expression: %s\n",tree->attr.name);
          break;
        default:
          fprintf(listing,"Unknown ExpNode kind\n");
          break;
      }
	}
    else if (tree->nodekind==DecK)
    { switch (tree->kind.dec) {
        case VarK:
          fprintf(listing,"Variable declared: %s\n",tree->child[1]->attr.name);
          break;
        case FunK:
          fprintf(listing,"Function declared: %s\n",tree->child[0]->attr.name);
          break;
      }
    }
    else if (tree->nodekind==ParamK)
    { switch (tree->kind.dec) {
        case NonK:
          fprintf(listing,"Void Parameter: %d, %s\n",tree->type,tree->child[0]->attr.name);
          break;
        case SingleK:
          fprintf(listing,"A Variable Parameter: %s\n",tree->attr.name);
          break;
        case ArrK:
          fprintf(listing,"A Variable Parameter: %s\n",tree->attr.name);
          break;
      }
    }
    else fprintf(listing,"Unknown node kind\n");
    for (i=0;i<MAXCHILDREN;i++)
         printTree(tree->child[i]);
    tree = tree->sibling;
  }
  UNINDENT;
}
