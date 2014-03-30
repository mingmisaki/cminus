#
# Makefile for TINY
# Gnu C Version
# K. Louden 2/3/98
#

CC = gcc
LEX = lex
CFLAGS = -g
LFLAGS = -ll

OBJS = main.o util.o lex.yy.o

cminus: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o cminus 

lex.yy.c: ./lex/cminus.l 
	$(LEX) ./lex/cminus.l

lex.yy.o: lex.yy.c globals.h util.h
	$(CC) -c lex.yy.c -lfl

main.o: main.c globals.h util.h 
	$(CC) $(CFLAGS) -c main.c

util.o: util.c util.h globals.h
	$(CC) $(CFLAGS) -c util.c

clean:
	-rm cminus 
	-rm tm
	-rm $(OBJS)
	-rm lex.yy.c
tm: tm.c
	$(CC) $(CFLAGS) tm.c -o tm

all: cminus tm

