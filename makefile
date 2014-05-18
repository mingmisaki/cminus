#
# Makefile for TINY
# Gnu C Version
# K. Louden 2/3/98
#

CC = gcc
LEX = flex
YACC = yacc
CFLAGS = -g
LFLAGS = -ll

OBJS = y.tab.o lex.yy.o util.o main.o

cminus: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o cminus -lfl 

y.tab.c: ./yacc/cminus.y
	$(YACC) -d -v ./yacc/cminus.y

y.tab.o: y.tab.c ./yacc/globals.h util.h
	$(CC) -c y.tab.c

lex.yy.c: ./lex/cminus.l 
	$(LEX) ./lex/cminus.l

lex.yy.o: lex.yy.c ./yacc/globals.h util.h
	$(CC) -c lex.yy.c 

main.o: main.c ./yacc/globals.h util.h 
	$(CC) $(CFLAGS) -c main.c

util.o: util.c util.h ./yacc/globals.h
	$(CC) $(CFLAGS) -c util.c

clean:
	-rm cminus 
	-rm $(OBJS)
	-rm lex.yy.c y.tab.c y.tab.h y.outout


all: cminus 

