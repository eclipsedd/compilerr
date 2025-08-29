FLEX = flex
CXX = g++
# CXXFLAGS = -Wall


SRC = src/lexer.l

LEXER_C = lexer.c
TARGET = lexer

all: clean fixscript $(TARGET)

fixscript:
	@sed -i 's/\r$$//' run.sh

$(TARGET): $(LEXER_C)
	@$(CXX) $(CXXFLAGS) -o $(TARGET) $(LEXER_C) -lfl

$(LEXER_C): $(SRC)
	@$(FLEX) -o $(LEXER_C) $(SRC)

clean:
	@rm -f $(TARGET) $(LEXER_C) *.o

.PHONY: all clean fixscript
