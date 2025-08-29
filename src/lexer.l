%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

const int ErrorTableSize = (1<<8);
struct ErrorEntry
{
    char* lexeme;
    char* error_msg;
    int line;
};
int err_count=0;
ErrorEntry ErrorTable[ErrorTableSize];

void addError(const char* msg, const char* lex, int l) {
    if (err_count < ErrorTableSize) {
        ErrorTable[err_count].error_msg = strdup(msg);
        ErrorTable[err_count].lexeme = strdup(lex);
        ErrorTable[err_count].line = l;
        err_count++;
    } else {
        printf("Error list is full. Cannot add more errors.\n");
    }
}

void printErrors(){
    printf("\n==================================================================================================================\n");
    printf("                                              ERROR REPORT\n");
    printf("==================================================================================================================\n");
    printf("| %-5s | %-40s | %-40s | %-15s |\n", "ID", "Description", "Token", "Line Number");
    printf("------------------------------------------------------------------------------------------------------------------\n");

    for (int i = 0; i < err_count; i++) {
        printf("| %-5d | %-40s | %-40s | %-15d |\n", 
               i + 1, 
               ErrorTable[i].error_msg,
               ErrorTable[i].lexeme,
               ErrorTable[i].line);
    }
    printf("==================================================================================================================\n");
}

const int SymbolTableSize = (1<<15);
struct SymbolEntry{
    char* lexeme;
    char* token;
    int line;
};
int sym_count=0;
SymbolEntry SymbolTable[SymbolTableSize];

void addSymbol(const char* lex, const char* tok, int l){

    if(sym_count >= SymbolTableSize)
    {
        addError("Symbol Table Filled!", lex, l);
        return;
    }

    SymbolTable[sym_count].lexeme = strdup(lex);
    SymbolTable[sym_count].token = strdup(tok);
    SymbolTable[sym_count].line = l;
    sym_count++;
}

void printSymbols(){
    printf("\n=========================================================================================================\n");
    printf("|                                            SYMBOL TABLE                                               |\n");
    printf("=========================================================================================================\n");
    printf("| %-40s | %-40s | %-15s |\n", "LEXEME", "TOKEN", "LINE");
    printf("---------------------------------------------------------------------------------------------------------\n");

    for (int i = 0; i < sym_count; i++) {
        printf("| %-40s | %-40s | %-15d |\n", 
               SymbolTable[i].lexeme, 
               SymbolTable[i].token, 
               SymbolTable[i].line);
    }

    printf("=========================================================================================================\n");
}
int lineno = 1;



/* to track column being read*/
int yycolumn = 1;

/* allowed simple escapes: \, ", n, r, t, 0 */
static int is_allowed_escape_char(char c)
{
    return (c == '\\' || c == '"' || c == 'n' || c == 'r' || c == 't' || c == '0');
}

/* update line/column from an arbitrary lexeme that may contain newlines */
static void update_line_col_from_text(const char *s, int len)
{
    int last_after_nl = 0;
    for (int i = 0; i < len; ++i)
    {
        if (s[i] == '\n' || s[i] == '\r')
        {
            ++lineno;
            last_after_nl = 0;
        }
        else
        {
            ++last_after_nl;
        }
    }
}

%}

%option noyywrap

/* macros */
DIGIT           [0-9] 
ID_START        [A-Za-z_] 
ID_CONT         [A-Za-z0-9_]
EXP             ([eE][+-]?{DIGIT}+)
FLOAT           ({DIGIT}+\.{DIGIT}*({EXP})?|\.{DIGIT}+({EXP})?|{DIGIT}+{EXP})
INT             {DIGIT}+
BOOL            (true|false)
IDENT           {ID_START}{ID_CONT}*
ESC_SEQ         (\\[nrt0\'\"\\])
CHAR_LIT        \'({ESC_SEQ}|[^\'\\\n\r])\'
LINE_COMMENT    (\/\/)[^\n\r]*
BLOCK_COMMENT   (\/\*)([^*]|\*+[^*/])*(\*\/)
PREPROC         [ \t]*\#[^\n\r]*


/* macros for keywords */
BOOL_KEYWORD     "bool"
CHAR_KEYWORD     "char"
INT_KEYWORD      "int"
FLOAT_KEYWORD    "float"
LONG_KEYWORD     "long"
SHORT_KEYWORD    "short"

CONST_KEYWORD    "const"
STATIC_KEYWORD   "static"
AUTO_KEYWORD     "auto"

IF_KEYWORD       "if"
ELSE_KEYWORD     "else"
FOR_KEYWORD      "for"
DO_KEYWORD       "do"
WHILE_KEYWORD    "while"
GOTO_KEYWORD     "goto"
BREAK_KEYWORD    "break"
CONTINUE_KEYWORD "continue"
SWITCH_KEYWORD   "switch"
CASE_KEYWORD     "case"
DEFAULT_KEYWORD  "default"

STRUCT_KEYWORD   "struct"
ENUM_KEYWORD     "enum"
UNION_KEYWORD    "union"

VOID_KEYWORD     "void"
RETURN_KEYWORD   "return"
TYPEDEF_KEYWORD  "typedef" 
SIZEOF_KEYWORD   "sizeof"
UNTIL_KEYWORD    "until"



/* macros for operators (single) */
ASSIGN              "="
PLUS                "+"
MINUS               "-"
STAR                "*"
SLASH               "/"
MOD                 "%"

TERNARY             "?"
COLON               ":"

BITWISE_AND         "&"
BITWISE_OR          "|"
BITWISE_XOR         "^"
BITWISE_NOT         "~"
NOT                 "!"
LESS_THAN           "<"
GREATER_THAN        ">"

/* macros for operators (multi)*/
INCR                 "++"
DECR                 "--"
LSHIFT               "<<"
RSHIFT               ">>"
ARROW                "->"
LESS_THAN_EQUAL      "<="
GREATER_THAN_EQUAL   ">="

EQUAL                "=="
NOT_EQUAL            "!="
AND                  "&&"
OR                   "||"

MULT_ASG             "*="
SLASH_ASG            "/="
MOD_ASG              "%="
PLUS_ASG             "+="
MINUS_ASG            "-="
LSHIFT_ASG           "<<="
RSHIFT_ASG           ">>="
AND_ASG              "&="
XOR_ASG              "^="
OR_ASG               "|="


/* macros for punctuations */
SEMICOLON           ";"
LSQ_BRACKET         "["
RSQ_BRACKET         "]"
L_BRACKET           "("
R_BRACKET           ")"
LCUR_BRACKET        "{"
RCUR_BRACKET        "}"
DOT                 "."
COMMA               ","



%%
{PREPROC}               { addSymbol(yytext, "PREPROC", lineno); }
nullptr|NULL            { addSymbol(yytext, "NULL LITERAL", lineno); }

{BOOL_KEYWORD}          { addSymbol(yytext, "BOOL_KEYWORD", lineno); }
{CHAR_KEYWORD}          { addSymbol(yytext, "CHAR_KEYWORD", lineno); }
{INT_KEYWORD}           { addSymbol(yytext, "INT_KEYWORD", lineno); }
{FLOAT_KEYWORD}         { addSymbol(yytext, "FLOAT_KEYWORD", lineno); }
{LONG_KEYWORD}          { addSymbol(yytext, "LONG_KEYWORD", lineno); }
{SHORT_KEYWORD}         { addSymbol(yytext, "SHORT_KEYWORD", lineno); }

{CONST_KEYWORD}         { addSymbol(yytext, "CONST_KEYWORD", lineno); }
{STATIC_KEYWORD}        { addSymbol(yytext, "STATIC_KEYWORD", lineno); }
{AUTO_KEYWORD}          { addSymbol(yytext, "AUTO_KEYWORD", lineno); }

{IF_KEYWORD}            { addSymbol(yytext, "IF_KEYWORD", lineno); }
{ELSE_KEYWORD}          { addSymbol(yytext, "ELSE_KEYWORD", lineno); }
{FOR_KEYWORD}           { addSymbol(yytext, "FOR_KEYWORD", lineno); }
{DO_KEYWORD}            { addSymbol(yytext, "DO_KEYWORD", lineno); }
{WHILE_KEYWORD}         { addSymbol(yytext, "WHILE_KEYWORD", lineno); }
{GOTO_KEYWORD}          { addSymbol(yytext, "GOTO_KEYWORD", lineno); }
{BREAK_KEYWORD}         { addSymbol(yytext, "BREAK_KEYWORD", lineno); }
{CONTINUE_KEYWORD}      { addSymbol(yytext, "CONTINUE_KEYWORD", lineno); }
{SWITCH_KEYWORD}        { addSymbol(yytext, "SWITCH_KEYWORD", lineno); }
{CASE_KEYWORD}          { addSymbol(yytext, "CASE_KEYWORD", lineno); }
{DEFAULT_KEYWORD}       { addSymbol(yytext, "DEFAULT_KEYWORD", lineno); }

{STRUCT_KEYWORD}        { addSymbol(yytext, "STRUCT_KEYWORD", lineno); }
{ENUM_KEYWORD}          { addSymbol(yytext, "ENUM_KEYWORD", lineno); }
{UNION_KEYWORD}         { addSymbol(yytext, "UNION_KEYWORD", lineno); }

{VOID_KEYWORD}          { addSymbol(yytext, "VOID_KEYWORD", lineno); }
{RETURN_KEYWORD}        { addSymbol(yytext, "RETURN_KEYWORD", lineno); }
{TYPEDEF_KEYWORD}       { addSymbol(yytext, "TYPEDEF_KEYWORD", lineno); }
{SIZEOF_KEYWORD}        { addSymbol(yytext, "SIZEOF_KEYWORD", lineno); }
{UNTIL_KEYWORD}         { addSymbol(yytext, "UNTIL_KEYWORD", lineno); }

{BOOL}                  { addSymbol(yytext, "BOOLEAN", lineno); }
{IDENT}                 { addSymbol(yytext, "IDENTIFIER", lineno); }
{FLOAT}([fF]?)          { addSymbol(yytext, "FLOAT", lineno); }
{INT}                   { addSymbol(yytext, "INTEGER", lineno); }
{CHAR_LIT}              { addSymbol(yytext, "CHAR", lineno); }




\"([^\\\"\n\r]|\\[\\\"nrt0]|\\\n\r)*\" {

    // String Literals


    int len = yyleng;
    for (int i = 0; i < len; ++i) {
        if (yytext[i] == '\\') {
            if (i + 1 >= len) {
                addError("Invalid Escape Sequence", "\\", lineno);
            } else {
                char esc = yytext[i+1];
                if (esc == '\n' || esc == '\r' ) {
                } else if (!is_allowed_escape_char(esc)) {
                    char badesc[3] = {'\\', esc, '\0'};
                    addError("Invalid Escape Sequence", badesc, lineno);
                }
                ++i; /* skip escaped char */
            }
        }
    }
    addSymbol(yytext,"STRING LITERAL",lineno);
    update_line_col_from_text(yytext, yyleng);
}

\"([^\\\"\n\r]|\\[\\\"nrt0]|\\\n\r)* {
    
    // Unterminated string 

    addError("Unterminated String Literal", yytext, lineno);
    update_line_col_from_text(yytext, yyleng);
}

{LINE_COMMENT}       { addSymbol(yytext, "LINE_COMMENT", lineno); }

{BLOCK_COMMENT}     { addSymbol(yytext, "BLOCK_COMMENT", lineno); update_line_col_from_text(yytext, yyleng); }





{INCR}               { addSymbol(yytext, "INCR", lineno); }
{DECR}               { addSymbol(yytext, "DECR", lineno); }
{LSHIFT}             { addSymbol(yytext, "LSHIFT", lineno); }
{RSHIFT}             { addSymbol(yytext, "RSHIFT", lineno); }
{ARROW}              { addSymbol(yytext, "ARROW", lineno); }
{LESS_THAN_EQUAL}    { addSymbol(yytext, "LESS_THAN_EQUAL", lineno); }
{GREATER_THAN_EQUAL} { addSymbol(yytext, "GREATER_THAN_EQUAL", lineno); }

{EQUAL}              { addSymbol(yytext, "EQUAL", lineno); }
{NOT_EQUAL}          { addSymbol(yytext, "NOT_EQUAL", lineno); }
{AND}                { addSymbol(yytext, "AND", lineno); }
{OR}                 { addSymbol(yytext, "OR", lineno); }

{MULT_ASG}           { addSymbol(yytext, "MULT_ASG", lineno); }
{SLASH_ASG}          { addSymbol(yytext, "SLASH_ASG", lineno); }
{MOD_ASG}            { addSymbol(yytext, "MOD_ASG", lineno); }
{PLUS_ASG}           { addSymbol(yytext, "PLUS_ASG", lineno); }
{MINUS_ASG}          { addSymbol(yytext, "MINUS_ASG", lineno); }
{LSHIFT_ASG}         { addSymbol(yytext, "LSHIFT_ASG", lineno); }
{RSHIFT_ASG}         { addSymbol(yytext, "RSHIFT_ASG", lineno); }
{AND_ASG}            { addSymbol(yytext, "AND_ASG", lineno); }
{XOR_ASG}            { addSymbol(yytext, "XOR_ASG", lineno); }
{OR_ASG}             { addSymbol(yytext, "OR_ASG", lineno); }

{ASSIGN}             { addSymbol(yytext, "ASSIGN", lineno); }
{PLUS}               { addSymbol(yytext, "PLUS", lineno); }
{MINUS}              { addSymbol(yytext, "MINUS", lineno); }
{STAR}               { addSymbol(yytext, "STAR", lineno); }
{SLASH}              { addSymbol(yytext, "SLASH", lineno); }
{MOD}                { addSymbol(yytext, "MOD", lineno); }

{TERNARY}            { addSymbol(yytext, "TERNARY", lineno); }
{COLON}              { addSymbol(yytext, "COLON", lineno); }

{BITWISE_AND}        { addSymbol(yytext, "BITWISE_AND", lineno); }
{BITWISE_OR}         { addSymbol(yytext, "BITWISE_OR", lineno); }
{BITWISE_XOR}        { addSymbol(yytext, "BITWISE_XOR", lineno); }
{BITWISE_NOT}        { addSymbol(yytext, "BITWISE_NOT", lineno); }
{NOT}                { addSymbol(yytext, "NOT", lineno); }
{LESS_THAN}          { addSymbol(yytext, "LESS_THAN", lineno); }
{GREATER_THAN}       { addSymbol(yytext, "GREATER_THAN", lineno); }




{SEMICOLON}          { addSymbol(yytext, "SEMICOLON", lineno); }
{LSQ_BRACKET}        { addSymbol(yytext, "LSQ_BRACKET", lineno); }
{RSQ_BRACKET}        { addSymbol(yytext, "RSQ_BRACKET", lineno); }
{L_BRACKET}          { addSymbol(yytext, "L_BRACKET", lineno); }
{R_BRACKET}          { addSymbol(yytext, "R_BRACKET", lineno); }
{LCUR_BRACKET}       { addSymbol(yytext, "LCUR_BRACKET", lineno); }
{RCUR_BRACKET}       { addSymbol(yytext, "RCUR_BRACKET", lineno); }
{DOT}                { addSymbol(yytext, "DOT", lineno); }
{COMMA}              { addSymbol(yytext, "COMMA", lineno); }


[ \t]+              {  }
\n                  { lineno++;}
\r                  { }

.   {   
    /* Single Invalid Character Error */
    char s[2] = {yytext[0], '\0'};
    addError("Invalid Character.", s, lineno);
}

{DIGIT}+{ID_START}+{ID_CONT}* {
    
    /* Invalid Lexeme Error */
    addError("Invalid Lexeme.", yytext, lineno);
}
%%

int main(int argc, char **argv)
{
    yylex();
    
    printErrors();
    printSymbols();

    return 0;
}