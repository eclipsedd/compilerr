# Makefile
FLEX = flex
CC = gcc
CFLAGS = -O2

TARGET = lexer

all: $(TARGET)

$(TARGET): lexer.c
	$(CC) $(CFLAGS) -o $(TARGET) lexer.c -lfl

lexer.c: src/lexer.l
	$(FLEX) -o lexer.c src/lexer.l

clean:
	rm -f lexer lexer.c *.o

.PHONY: all clean
