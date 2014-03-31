#
# Makefile for TINY
# Gnu C Version
# K. Louden 2/3/98
#

CC = gcc
LEX = flex
CFLAGS = -g
LFLAGS = -ll

OBJS = main.o util.o lex.yy.o

cminus: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o cminus -lfl 

lex.yy.c: ./lex/cminus.l 
	$(LEX) ./lex/cminus.l

lex.yy.o: lex.yy.c globals.h util.h
	$(CC) -c lex.yy.c 

main.o: main.c globals.h util.h 
	$(CC) $(CFLAGS) -c main.c

util.o: util.c util.h globals.h
	$(CC) $(CFLAGS) -c util.c

clean:
	-rm cminus 
	-rm $(OBJS)
	-rm lex.yy.c

all: cminus 

