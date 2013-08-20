OBJS = bison.o lex.o

CC = gcc

CFLAGS = -g -Wall -ansi -pedantic


parser: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o mini_l -lfl

bison.o: bison.c
	$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c: mini_l.y
	bison -d -v mini_l.y
	mv mini_l.tab.c bison.c
	cmp -s mini_l.tab.h tok.h || mv mini_l.tab.h tok.h

lex.o: lex.c
	$(CC) $(CFLAGS) -c lex.c -o lex.o	

lex.c: mini_l.l
	flex mini_l.l
	mv lex.yy.c lex.c

clean:
	rm -f $(OBJ) *.c *.h mini_l *.o mini_l.output
