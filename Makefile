FLEX = flex
CC = gcc
CFLAGS = -O2
SRC = src/lexer.l


fixscript:
	dos2unix run.sh

TARGET = lexer
LEXER_C = lexer.c

all: $(TARGET)

$(TARGET): $(LEXER_C)
	$(CC) $(CFLAGS) -o $(TARGET) $(LEXER_C) -lfl

$(LEXER_C): $(SRC)
	@mkdir -p $(dir $@)
	$(FLEX) -o $(LEXER_C) $(SRC)

clean:
	rm -f $(TARGET) $(LEXER_C) *.o

.PHONY: all clean
